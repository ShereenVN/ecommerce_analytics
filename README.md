# E-Commerce Analytics Pipeline

A dbt analytics pipeline built on the TheLook E-Commerce public dataset, transforming raw transactional data into a clean star schema optimised for business analysis. Includes stakeholder-facing mart models for traffic, conversion and fulfilment analysis.

---

## Overview

This project demonstrates a modern ELT analytics engineering workflow. Raw e-commerce data is loaded from a public BigQuery dataset and transformed through a layered dbt project into business-ready dimension, fact and mart tables.

The pipeline covers orders, customers, products, order line items and user events. Each layer enriches the data with derived metrics such as lifetime order counts, total revenue per product, per-item profit margins, conversion funnel rates and order fulfilment times.

**Dataset:** [TheLook E-Commerce](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce). A fictional e-commerce platform dataset provided by Google as a BigQuery public dataset. It contains order, customer, product, inventory and event data spanning January 2019 to present.

**Stack:**
- [dbt](https://www.getdbt.com/) for transformation and testing
- [Google BigQuery](https://cloud.google.com/bigquery) as the data warehouse
- Google Cloud service account for authentication

---

## Architecture

Data flows through two layers before reaching the final analytical models:

```
bigquery-public-data.thelook_ecommerce  (source)
            │
            ▼
    models/staging/thelook              (staging layer: views)
            │
            ▼
    models/marts/core                   (marts layer: tables)
```

**Staging layer** cleans and renames raw source columns, standardises data types and applies source-level data quality filters. Materialised as views.

**Marts layer** applies business logic, joins related staging models and computes derived metrics. Materialised as tables for query performance. Includes both core dimensional models and stakeholder-facing mart models.

### Model Reference

| Model | Layer | Type | Description |
|---|---|---|---|
| `stg_thelook__orders` | Staging | View | Cleaned order transactions with standardised column names and status values |
| `stg_thelook__order_items` | Staging | View | Individual line items per order with sale price and fulfilment timestamps |
| `stg_thelook__products` | Staging | View | Product catalogue with category, brand and cost. NULL product names are excluded. |
| `stg_thelook__users` | Staging | View | Customer registration data with demographic and geographic fields |
| `stg_thelook__events` | Staging | View | User interaction events including page views, cart adds and purchases. Used for funnel analysis. |
| `dim_customers` | Marts | Table | Customer dimension enriched with first order date, most recent order date and lifetime order count |
| `dim_products` | Marts | Table | Product dimension with unit profit margin, total times sold and total revenue |
| `fct_order_items` | Marts | Table | Fact table. One row per order line item with full order context, product context and item-level profit. |
| `mart_traffic_source_revenue` | Marts | Table | Monthly revenue, order count and average order value broken down by traffic source |
| `mart_order_fulfillment` | Marts | Table | Monthly fulfilment times, return rates and cancellation rates broken down by product category |
| `mart_traffic_source_conversion` | Marts | Table | Monthly conversion funnel metrics (product views → cart adds → purchases) broken down by traffic source |

---

## Star Schema

```
                    ┌─────────────────┐
                    │  dim_customers  │
                    │─────────────────│
                    │ customer_id (PK)│
                    │ first_name      │
                    │ last_name       │
                    │ email           │
                    │ country         │
                    │ lifetime_orders │
                    └────────┬────────┘
                             │
                             │ customer_id
                             │
┌─────────────────┐  order_id + customer_id + product_id  ┌─────────────────┐
│  dim_products   │◄──────────────────────────────────────│ fct_order_items │
│─────────────────│                                        │─────────────────│
│ product_id (PK) │                                        │ order_item_id   │
│ product_name    │                                        │ order_id        │
│ product_category│                                        │ customer_id     │
│ brand           │                                        │ product_id      │
│ retail_price    │                                        │ order_status    │
│ product_cost    │                                        │ sale_price      │
│ unit_margin     │                                        │ item_profit     │
│ total_revenue   │                                        │ ordered_at      │
└─────────────────┘                                        └─────────────────┘
```

---

## Stakeholder Mart Models

Three mart models have been built in response to real stakeholder requests, following an analytics engineering workflow that includes clarifying questions, data exploration and documented assumptions before building.

**`mart_traffic_source_revenue`**: Built for the Marketing Director. Shows monthly total orders, customer count, total revenue and average order value per traffic source. Answers: which channels drive the most revenue?

**`mart_order_fulfillment`**: Built for the Head of Operations. Shows monthly average days to ship, average days to deliver, return rate and cancellation rate per product category. Negative fulfilment times (data quality issue in source) are excluded. Answers: which categories have the worst fulfilment performance?

**`mart_traffic_source_conversion`**: Built for the Marketing Director as a follow-up. Shows monthly product viewers, cart adds, purchasers, product-to-cart rate and cart-to-purchase rate per traffic source. Anonymous users are excluded as they never reach the purchase step. Answers: which channels have the best conversion through the funnel?

---

## Testing

47 dbt tests are defined across the staging and marts layers, covering:

**Generic tests:**
- `not_null`: applied to all primary and foreign keys, and critical measure columns
- `unique`: applied to all primary keys to enforce row-level uniqueness
- `accepted_values`: applied to `order_status` and `event_type` to ensure only known values are present
- `relationships`: applied to foreign keys in `fct_order_items` to ensure referential integrity against `dim_customers` and `dim_products`

**Data quality decisions made during development:**
- 2 rows with NULL `product_name` were discovered in the source products table and filtered out at the staging layer. The filter was propagated to `fct_order_items` to maintain referential integrity across the pipeline.
- Negative fulfilment times were discovered in the source data (shipped_at earlier than ordered_at) and excluded from `mart_order_fulfillment` calculations.
- Anonymous users (NULL user_id) are excluded from `mart_traffic_source_conversion` as they never reach the purchase step, making them irrelevant to funnel conversion analysis.

Run all tests with:
```bash
dbt test
```

---

## How to Run

### Prerequisites

- Python 3.8+
- dbt-bigquery installed (`pip install dbt-bigquery`)
- A Google Cloud project with BigQuery enabled
- A service account with BigQuery Data Viewer and BigQuery Job User roles
- Access to `bigquery-public-data` (ensure your GCP project is set to US region)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/ShereenVN/ecommerce_analytics.git
cd ecommerce_analytics
```

2. Configure your dbt profile at `~/.dbt/profiles.yml`:
```yaml
ecommerce_analytics:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: your-gcp-project-id
      dataset: ecommerce_analytics
      keyfile: /path/to/your/keyfile.json
      location: US
      threads: 4
```

3. Verify your connection:
```bash
dbt debug
```

### Key Commands

```bash
dbt run                                         # Build all models
dbt test                                        # Run all tests
dbt run --select stg_thelook__orders            # Build a single model
dbt run --select +fct_order_items               # Build a model and all its upstream dependencies
dbt run --full-refresh                          # Rebuild all table materialisations from scratch
dbt run --select mart_traffic_source_revenue    # Build a specific mart model
```

---

## Built With

- [dbt](https://www.getdbt.com/): data transformation and testing framework
- [Google BigQuery](https://cloud.google.com/bigquery): cloud data warehouse
- [TheLook E-Commerce Dataset](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce): public BigQuery dataset by Google
