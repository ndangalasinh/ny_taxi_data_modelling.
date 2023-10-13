# Data Engineering End to End Project: Analysis of NYC Taxi & Limousine Commission data

## Tech Stack
- Prefect
    - Workflow orchestration tool for data https://www.prefect.io/
- Google BigQuery
    - Google's fully managed, serverless data warehouse that enables scalable analysis over petabytes of data. 
- DBT
    - An open-source command line tool that helps analysts and engineers transform data in their warehouse more effectively.
- Google Data Studio
    - A web-based data visualization tool that helps users build customized dashboards and easy-to-understand reports.
## Overview
This is end to end Data Engineering project where data is fetched batch processed and then made readily available for analysis. This data is being fetched from the NYC Taxi & Limousine Commision's website https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page, get processed, and then stored into  Google's fully managed serverless data warehouse. This data is then modelled using DBT to create several tables that then will be used by analysts to create dashboards and analysis.


Similar project was demonstrated in the Data Engineering Zoomcamp run by Data Talks Club(DTC), while I have altered some of the implementation I have borrowed most of their ideas. I highly recommend for this boot camp for novice Data Engineers, they can be found here https://datatalks.club/.
## Project's main components
Implementation of this project can be done in three main parts. First Data Aquisation, processing and Storage which covers the whole process of fetching and transforming the fetched data before being stored this whole process is automated by Orchestration and Scheduling tool Prefect. Second stage of this project is modelling the stored data into tables that caters to the needs of the analysts, DBT is the tool we are using in this project for data modelling. The last stage is to create visualization and reporting from the modelled data, here we have used Google's data studio as the reporting tool.

### Data Aquisation, Processing, and Storage.(with Orchestration and Scheduling) 
In this part data is downloaded from the source, processed and then stored in a storage, this process is autmoated by using Orchestratation tools.
There are multiple options of what tools you can use to orchestrate and monitor your scheduled data pipelines, in this case Prefect from https://www.prefect.io/ was used.

After the pipeline was set, a deployment with desired scheduling and monitoring was set configured and deployed.
ALTENATIVE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
CCCCXXXXX

#### Data Aquisation 
As explained above this data is being fetched from the NYC Taxi & Limousine Commission website, since this data is is available as in parquet format then we can directly fetch it into a pandas dataframe. The way data is fetched is different depending if we have the previous data already or not as discussed bellow.
##### First time (initial) Aquisation
In the case that this is the first time we are loading this data then we will have to load all the previous datasets. Care has to be given to attend the fact that you might not want to load all the data set if you do not have enough storage.
##### Routine Aquisation 
In this case data is loaded on a regular cadance ie once a month so we only load the data that was not loaded last time we loaded data. The simple way to do so is by looking at the current date and then obtain the valu to represent the previous month and use that to select needed data set.

#### Processing
After datqa aquisation now we can do some processing before we store this data into the Google's Bigquery, it is very important not to do a lot of modification here because we going to store this data in its crude format and downstream will model few tables that we need to keep.
In this case in particular only few columns were renamed and some rows that could cause issues downstream were removed.

#### Data storage 
The slightly modified data now is ready to be stored in BigQuery, we will store this data into two different tables. Data from the green taxi will be stored in green rides table and that from the yellow taxi will be stored in yellow rides table.

 
### Data Modelling 
Now that we have data in our storage we will have to prepare it to be able to be used, in simple case the analysts can easilty access the data from this storage and build dashbord or perfom analysis without a problem. But in cases where there is a lot of data from different sources a warehouse can easily end up being confusing and not having advantages we anticipate a warehouse to have. Hence it is very important to get into a behavior of modelling this data into the easily consumed form ie by combining some tables.

We are using DBT as a tool to model data, DBT is very familiar among data engineers in data modelling.
#### Data will be modelled as follows
For context DBT uses the tables that we generated when we stored data in the data warehouse to generate either tables or views which can be used to generate final tables that our analysts will use.
In this case we have some views that are derived from the tables and then we are using those fews to create tables in Core which are made available to the analysts
1. Core 
    - zones_ny Table
    - facts_trip Table
    - monthly_zone_revenue Table
    - monthly_zone_riders Table
1. Staging
    - stg_greeen_tripdata View
    - stg_yellow_tripdata View
#### Seeding(This is used to load files that do not change often)
Seeding is used to upload data into the warehouse, the difference is this is data that might not be changing often so we only do this once.
- we are only seeding a look up file taxi_zone_lookup.cv for the ny zones
#### Testing in our models is implemented as follows
Only the basic tests have been implemented via schema of the models as follows
1. stg_green_tripdata 
    - columns to be tested 
        - tripid:
            - Tests: 
                1. Not Null warn
                1. Unique warn
        - vendorid
            - Tests:
                1. Relationship with locationid warn
        - dropoff_locationid
            - Tests:
                1. Relationship with locationid warn
        - payment_type
            - Tests:
                1. accepted_values warn
TODO add more testing
#### Macros
We only have few macros that decode some of the basic information which was not given directly
- get_payment_type_description.sql
- get_ratecode_description.sql
- get_triptype_description.sql
- get_vendorid_description.sql

### Data visualization on Google Data Studio
I have demonstrated data visualization of this modelled data using Google Data Studio for simplicity, you can acess that visualizaion here https://lookerstudio.google.com/reporting/990a2679-8d75-413b-9ec7-80d3c2595987

Different tools can be used in this case such as PowerBI, Tableau, or Sisense

## How to implement this project 
### part 1
1. Clone the repository 
```
git clone https://github.com/ndangalasinh/ny_taxi_data.git

```
1. Create virtual env
It is a good practice to create a virtual environment where we will implement this project, there are a number of options to do this. I am using conda, you should feel free to use the method you are confident with.

    - If you do not have conda yet you should install it
    ```
    pip install conda
    ```
    - Then you can create you own virtual en
    ```
    conda create --name myenv python=3.9
    ```
1. Activate the virtual environment you have just created
    ```
    conda activate myenv
    ```
1. Navigate into the cloned directory
1. Install the required requirements from the requirements.txt into your virtual env
    ```
    pip install -r requirements.txt
    ```
1. If you do not have a gcp account create one
    1. What you need
        - A valid Gmail ID
        - Credit card and a phone number (While you can use the free tier but payment method is needed to set up)
    1. Navigate to the GCP home page(https://cloud.google.com/free).
    1. Click on the Start free button
    1. Sign in with your Gmail ID.
    1. Select your country from the drop-down, accept the terms of service, and then click on continue
    1. Enter the Business name and Enter payment method.
    1. Start my Free Trial.
    1. Complete the payment and your free trial will start (Small amount of money will be deducted and then it will be refunded later)

1. Settup a service account and download the key credentials in your local machine in JSON format
    1. Go to https://console.cloud.google.com/apis/credentials/wizard
    1. Make sure your project is selected on the header of the page
    1. From the Select an API dropdown, choose BigQuery API
    1. Select Application data for the type of data you will be accessing
    1. Select No, I’m not using them and click Next.
    1. Click Next to create a new service account
    1. Type any name as the Service account name
    1. From the Select a role dropdown, choose BigQuery Admin and click Continue
    1. Leave the Grant users access to this service account fields blank
    1. Click Done
    1. Create a service account key for your new project from the Service accounts page
    1. When downloading the JSON file, make sure to use a filename you can easily remembe
1. start the prefect agent in your terminal
      ```
      prefect agent start default
      ```
1. Start prefect server
    ```
    prefect server start
    ```
1. Open the localhost by following the link shown on your terminal from step above
1. Create GCP credentials block in your prefect UI
    1. Go to blocks
    1. Click the + sign and search for GCP credentials
    1. Click add Block to add this block
    1. Give the block a name (its recommended to use "gcp-credentials" or if you use other name remember to change the same in the etl.py and otherXXXXXXXXX)
1. Now you can upload data to your storage
    - For the initial load run etl.py, later we will deploy a job that will be uploading data after everymonth

### part 2
#### Create a repository
1. Create a personal repository on Github pointing it to your local directory for this projet
#### Start a project inside DBT
1. create account with DBT cloud
1. Create a new project in dbt Cloud. From Account settings (using the gear menu in the top right corner), click + New Project.
1. Enter a project name and click Continue.
1. For the warehouse, click BigQuery then Next to set up your connection.
1. Click Upload a Service Account JSON File in settings.
1. Select the JSON file you downloaded in Generate BigQuery credentials and dbt Cloud will fill in all the necessary fields.
1. Click Test Connection. This verifies that dbt Cloud can access your BigQuery account.
1. Click Next if the test succeeded. If it failed, you might need to go back and regenerate your BigQuery credentials.
1. Under "Setup a repository", select Managed.
1. Type a name for your repo such as bbaggins-dbt-quickstart
1. Click Create. It will take a few seconds for your repository to be created and imported.
1. Once you see the "Successfully imported repository," click Continue.
#TODO Check the behavior when you connect and existing dbt repo


### part 3 
1. Automate data aquisation
1. Automate data modelling
#### Create a Deployment
1. In the upper left, select Deploy, then click Environments.
1. Click Create Environment.
1. In the Name field, write the name of your deployment environment. For example, "Production."
1. In the dbt Version field, select the latest version from the dropdown.
1. Under Deployment Credentials, enter the name of the dataset you want to use as the target, such as "Analytics". This will allow dbt to build and work with that dataset. For some data warehouses, the target dataset may be referred to as a "schema".
1. Click Save.

#### Scheduling a deployment
1. After creating your deployment environment, you should be directed to the page for a new environment. If not, select Deploy in the upper left, then click Jobs.
1. Click Create one and provide a name, for example, "Production run", and link to the Environment you just created.
1. Scroll down to the Execution Settings section.
1. Under Commands, add this command as part of your job if you don't see it:
    - dbt build
1. Select the Generate docs on run checkbox to automatically generate updated project docs each time your job runs.
1. For this exercise, do not set a schedule for your project to run — while your organization's project should run regularly, there's no need to run this example project on a schedule. Scheduling a job is sometimes referred to as deploying a project.
1. Select Save, then click Run now to run your job.
1. Click the run and watch its progress under "Run history."
1. Once the run is complete, click View Documentation to see the docs for your project.


### part 4
1. Data visualization




