DE_case_study_xeneta_takehome_task
=====================

This is a  [dbt](https://www.getdbt.com/) project used for Xeneta takehome task with DuckDB as [duckdb](https://duckdb.org/) as backend db.


The goal was to load initial data from the given files to a database
and then create daily regional aggregated prices based on port-to-port contract data with the help of DBT.

## Design

### Load and transform data
For initial load, I have kept the csv files in the seeds directory. I am using the seed directory to load the data into thr `raw` schema. Then creating `staging` layer based on this data. `final` layer takes care of creating final `prices` and `aggregations` models.
It also caters for the creating a view to help end-user requirement.

### Help your data users
For this requirement, I have created a view and sameple queries are placed in `analyze` directory

### Data update: new contracts
I am inreamenatlly loading the data in `append` mode based on the dbt [incremental](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations#incremental)

### Requirement update
This requirement also been taken care in the final layer.


## Running this Project

To get up and running with this project:
1. Install dbt using [these instructions](https://docs.getdbt.com/docs/installation).

2. Clone this repository.

3. Change into the `xeneta_take_home_task` directory from the command line:
```bash
$ cd xeneta_take_home_task
```

4. As part of this code a profile.yaml has been add. But one can set up a profile called `profile.yaml` to connect to a data warehouse by following [these instructions](https://docs.getdbt.com/docs/configure-your-profile). If you have access to a data warehouse, you can use those credentials – we recommend setting your [target schema](https://docs.getdbt.com/docs/configure-your-profile#section-populating-your-profile) to be a new schema (dbt will create the schema for you, as long as you have the right privileges). If you don't have access to an existing data warehouse, you can also setup a local postgres database and connect to it in your profile.

5. Ensure your profile is setup correctly from the command line:
```bash
$ dbt debug
```

6. Load the CSVs with the demo data set. This materializes the CSVs as tables in your target schema. Note that a typical dbt project **does not require this step** since dbt assumes your raw data is already in your warehouse.
```bash
$ dbt seed
```

7. Run the models:
```bash
$ dbt run
```

> **NOTE:** If this steps fails, it might mean that you need to make small changes to the SQL in the models folder to adjust for the flavor of SQL of your target database. Definitely consider this if you are using a community-contributed adapter.

8. Test the output of the models:
```bash
$ dbt test
```

9. Generate documentation for the project:
```bash
$ dbt docs generate
```

10. View the documentation for the project:
```bash
$ dbt docs serve
```
