avaintha@Shereen-PC:~/Documents/ecommerce_analytics$ dbt test
dbt-fusion 2.0.0-preview.193
   Loading ~/.dbt/profiles.yml
New version available 2.0.0-preview.196 (run `dbt system update`)

=================================================================================================== Errors and Warnings ===================================================================================================
[error] [DbtYamlValidationError (dbt1159)]: Deprecated test arguments: ["field", "to"] at top-level detected. Please migrate to the new format under the 'arguments' field: https://docs.getdbt.com/reference/deprecations#missingargumentspropertyingenerictestdeprecation.
  --> models/marts/core/_core__models.yml:52:22
[error] [DbtYamlValidationError (dbt1159)]: Deprecated test arguments: ["field", "to"] at top-level detected. Please migrate to the new format under the 'arguments' field: https://docs.getdbt.com/reference/deprecations#missingargumentspropertyingenerictestdeprecation.
  --> models/marts/core/_core__models.yml:59:22
[error] [DbtYamlValidationError (dbt1159)]: Deprecated test arguments: ["values"] at top-level detected. Please migrate to the new format under the 'arguments' field: https://docs.getdbt.com/reference/deprecations#missingargumentspropertyingenerictestdeprecation.
  --> models/staging/thelook/_thelook__models.yml:21:23
[warning] [UnusedResourceConfigPath (dbt1097)]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:
- models.ecommerce_analytics.example
suggestion: Run 'dbt deps' to see the latest fusion compatible packages. For compatibility errors, try the autofix script: https://github.com/dbt-labs/dbt-autofix

==================================================================================================== Execution Summary ====================================================================================================
Finished 'test' with 1 warning and 3 errors for target 'dev' [436ms]


avaintha@Shereen-PC:~/Documents/ecommerce_analytics$ dbt test
dbt-fusion 2.0.0-preview.193
   Loading ~/.dbt/profiles.yml
    Passed [  2.52s] test  not_null_stg_thelook__orders_order_id
    Passed [  2.52s] test  not_null_dim_customers_lifetime_order_count
    Passed [  2.54s] test  not_null_stg_thelook__users_customer_id
    Passed [  2.54s] test  not_null_fct_order_items_product_id
    Passed [  2.54s] test  not_null_stg_thelook__order_items_product_id
    Passed [  2.55s] test  not_null_stg_thelook__users_email
    Passed [  2.57s] test  not_null_stg_thelook__order_items_sale_price
    Passed [  2.57s] test  unique_dim_products_product_id
    Passed [  2.58s] test  not_null_stg_thelook__products_product_id
    Passed [  2.58s] test  not_null_dim_products_product_category
    Passed [  2.59s] test  unique_stg_thelook__users_customer_id
    Passed [  2.60s] test  not_null_fct_order_items_sale_price
    Passed [  2.64s] test  unique_stg_thelook__orders_order_id
    Passed [  2.65s] test  not_null_stg_thelook__order_items_order_item_id
    Passed [  2.66s] test  not_null_dim_products_product_id
    Passed [  2.67s] test  unique_stg_thelook__order_items_order_item_id
    Passed [  2.70s] test  not_null_dim_products_retail_price
    Passed [  2.71s] test  not_null_stg_thelook__products_product_category
    Passed [  2.71s] test  relationships_fct_order_items_product_id__product_id__ref_dim_products_
    Passed [  2.72s] test  unique_stg_thelook__products_product_id
    Passed [  2.73s] test  not_null_stg_thelook__orders_customer_id
    Failed [  2.78s] test  not_null_stg_thelook__products_product_name (models/staging/thelook/_thelook__models.yml:56:13)
    Passed [  2.79s] test  not_null_stg_thelook__orders_order_status
    Passed [  2.80s] test  relationships_fct_order_items_customer_id__customer_id__ref_dim_customers_
    Passed [  2.89s] test  unique_dim_customers_customer_id
    Passed [  3.02s] test  accepted_values_stg_thelook__orders_order_status__Shipped__Complete__Returned__Cancelled__Processing
    Passed [  3.06s] test  unique_fct_order_items_order_item_id
    Passed [  3.06s] test  not_null_dim_customers_customer_id
    Passed [  3.18s] test  not_null_fct_order_items_order_item_id
    Passed [  3.22s] test  not_null_fct_order_items_customer_id
    Passed [  3.38s] test  not_null_fct_order_items_order_id
    Passed [  3.38s] test  not_null_stg_thelook__order_items_order_id
New version available 2.0.0-preview.196 (run `dbt system update`)

=================================================================================================== Errors and Warnings ===================================================================================================
[warning] [UnusedResourceConfigPath (dbt1097)]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:
- models.ecommerce_analytics.example

==================================================================================================== Execution Summary ====================================================================================================
Finished 'test' with 1 warning and 1 error for target 'dev' [3.5s]
Processed: 32 tests
Summary: 32 total | 31 success | 1 error

-- There's 2 NULLs in product name, thus I have added a WHERE clause that excludes them in the stg_the_look__products.sql file. Rebuilt the model and then the test was succesful.

avaintha@Shereen-PC:~/Documents/ecommerce_analytics$ dbt test
dbt-fusion 2.0.0-preview.193
   Loading ~/.dbt/profiles.yml
    Passed [  1.96s] test  not_null_stg_thelook__order_items_order_item_id
    Passed [  1.99s] test  unique_stg_thelook__orders_order_id
    Passed [  2.22s] test  not_null_dim_products_product_id
    Passed [  2.32s] test  not_null_fct_order_items_customer_id
    Passed [  2.36s] test  not_null_dim_products_product_category
    Passed [  2.43s] test  not_null_stg_thelook__orders_order_status
    Passed [  2.48s] test  not_null_stg_thelook__users_customer_id
    Passed [  2.58s] test  not_null_stg_thelook__order_items_sale_price
    Passed [  2.58s] test  not_null_stg_thelook__users_email
    Passed [  2.60s] test  not_null_dim_customers_lifetime_order_count
    Passed [  2.64s] test  not_null_stg_thelook__orders_order_id
    Passed [  2.66s] test  not_null_fct_order_items_order_item_id
    Passed [  2.69s] test  not_null_fct_order_items_order_id
    Passed [  2.72s] test  not_null_stg_thelook__order_items_product_id
    Passed [  2.76s] test  accepted_values_stg_thelook__orders_order_status__Shipped__Complete__Returned__Cancelled__Processing
    Passed [  2.84s] test  not_null_stg_thelook__products_product_category
    Passed [  2.87s] test  not_null_fct_order_items_sale_price
    Passed [  2.89s] test  unique_stg_thelook__users_customer_id
    Passed [  2.92s] test  unique_fct_order_items_order_item_id
    Passed [  2.95s] test  not_null_stg_thelook__products_product_id
    Passed [  2.96s] test  unique_dim_customers_customer_id
    Passed [  3.02s] test  unique_stg_thelook__order_items_order_item_id
    Passed [  3.04s] test  unique_stg_thelook__products_product_id
    Passed [  3.04s] test  not_null_stg_thelook__products_product_name
    Passed [  3.07s] test  not_null_stg_thelook__orders_customer_id
    Passed [  3.20s] test  not_null_stg_thelook__order_items_order_id
    Failed [  3.22s] test  relationships_fct_order_items_product_id__product_id__ref_dim_products_ (models/marts/core/_core__models.yml:58:13)
    Passed [  3.28s] test  not_null_fct_order_items_product_id
    Passed [  3.29s] test  not_null_dim_customers_customer_id
    Passed [  3.37s] test  not_null_dim_products_retail_price
    Passed [  3.66s] test  unique_dim_products_product_id
    Passed [  3.68s] test  relationships_fct_order_items_customer_id__customer_id__ref_dim_customers_
New version available 2.0.0-preview.196 (run `dbt system update`)

=================================================================================================== Errors and Warnings ===================================================================================================
[warning] [UnusedResourceConfigPath (dbt1097)]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:
- models.ecommerce_analytics.example

==================================================================================================== Execution Summary ====================================================================================================
Finished 'test' with 1 warning and 1 error for target 'dev' [3.8s]
Processed: 32 tests
Summary: 32 total | 31 success | 1 error

--So this error was because of the 2 NULLs still being in the join fact table. I had to also use a WHERE clause to filter out those NULLs and rebuild the table to fix the issue.

avaintha@Shereen-PC:~/Documents/ecommerce_analytics$ dbt test
dbt-fusion 2.0.0-preview.193
   Loading ~/.dbt/profiles.yml
    Passed [  2.26s] test  unique_stg_thelook__products_product_id
    Passed [  2.29s] test  unique_stg_thelook__order_items_order_item_id
    Passed [  2.29s] test  not_null_stg_thelook__users_email
    Passed [  2.32s] test  not_null_stg_thelook__products_product_category
    Passed [  2.33s] test  not_null_stg_thelook__orders_order_status
    Passed [  2.39s] test  not_null_stg_thelook__users_customer_id
    Passed [  2.42s] test  not_null_fct_order_items_sale_price
    Passed [  2.43s] test  not_null_stg_thelook__order_items_sale_price
    Passed [  2.44s] test  unique_stg_thelook__users_customer_id
    Passed [  2.45s] test  not_null_dim_products_retail_price
    Passed [  2.47s] test  unique_stg_thelook__orders_order_id
    Passed [  2.51s] test  unique_dim_customers_customer_id
    Passed [  2.52s] test  not_null_stg_thelook__products_product_name
    Passed [  2.54s] test  not_null_dim_customers_lifetime_order_count
    Passed [  2.55s] test  not_null_stg_thelook__order_items_order_id
    Passed [  2.63s] test  not_null_stg_thelook__orders_order_id
    Passed [  2.64s] test  not_null_dim_products_product_category
    Passed [  2.67s] test  accepted_values_stg_thelook__orders_order_status__Shipped__Complete__Returned__Cancelled__Processing
    Passed [  2.69s] test  unique_fct_order_items_order_item_id
    Passed [  2.69s] test  not_null_stg_thelook__order_items_order_item_id
    Passed [  2.70s] test  unique_dim_products_product_id
    Passed [  2.70s] test  not_null_fct_order_items_order_id
    Passed [  2.73s] test  not_null_stg_thelook__order_items_product_id
    Passed [  2.76s] test  not_null_stg_thelook__orders_customer_id
    Passed [  2.84s] test  not_null_fct_order_items_customer_id
    Passed [  2.87s] test  not_null_dim_products_product_id
    Passed [  2.98s] test  not_null_dim_customers_customer_id
    Passed [  3.02s] test  not_null_stg_thelook__products_product_id
    Passed [  3.03s] test  not_null_fct_order_items_order_item_id
    Passed [  3.03s] test  not_null_fct_order_items_product_id
    Passed [  3.10s] test  relationships_fct_order_items_customer_id__customer_id__ref_dim_customers_
    Passed [  3.26s] test  relationships_fct_order_items_product_id__product_id__ref_dim_products_
New version available 2.0.0-preview.196 (run `dbt system update`)

=================================================================================================== Errors and Warnings ===================================================================================================
[warning] [UnusedResourceConfigPath (dbt1097)]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:
- models.ecommerce_analytics.example

==================================================================================================== Execution Summary ====================================================================================================
Finished 'test' with 1 warning for target 'dev' [3.4s]
Processed: 32 tests
Summary: 32 total | 32 success