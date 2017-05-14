#DHIS2_CLI

## Intro  

Dhis2 cli is command line wrapper for quickly maintaining (deploying, cloning...)
and executing specific operations on DHIS2 instances.

Example: 

  - installing dhis2 
  - copy organisation units from one dhis2 to another
  - loading cvs file into dhis2 
  - mass deleting data elements 
  - ...

## Installation  
  
  - basic installation 
   
   ```
   git clone https://github.com/BLSQ/dhis2_cli.git 
   gem build dhis2_cli.gemspec
   gem install dhis2_cli
   ```

  - heroku 

  If you use heroku to deploy your instance, you'll have to enable the 
  following environment variable 
  
  ```
  export HEROKU_TOKEN=heroku_oauth_token
  export DHIS2_CLI_COLLABORATORS=comma_separated_emails
  ```


## Usage 

DHIS2_CLI command line is splitted in multiple namespaces. Select the namespace 
depending on which commands you want to perform. Here is an exhaustive list of 
the available namespace and their corresponding commands.

  ```
  dhis2_cli heroku        #Maintain DHIS2 instances on heroku
        Commands:
          dhis2_cli.rb heroku help [COMMAND]       # Describe subcommands or one specific subcommand
          dhis2_cli.rb heroku install --name=NAME  # Create Heroku app with name and install dhis2 instance

  dhis2_cli orgunit       #Perform Organisation units maintenance operations
        Commands:
          dhis2_cli.rb org_unit copy --dest=DEST --source=SOURCE  # copy orgunits from one instance to another
          dhis2_cli.rb org_unit help [COMMAND]                    # Describe subcommands or one specific subcommand  
  ```

## Heroku namespace
 
### Install 

Install DHIS2 as an heroku app

``` 
./dhis2_cli heroku install --name heroku_app_name                  [REQUIRED]
                           --version dhis2_version_to_be_installed [DEFAULT: 2.25]
                           --sql-file sql_file_path                [OPTIONAL] 
                           --db_plan heroku_db_plan                [DEFAULT: hobby-dev]
```

- Example install dhis 2.22 in test_app 

``` 
./dhis2_cli heroku install --name test_app
                           --version 2.22 

```

## Orgunit namespace

### Copy 

Copy organisation units from one DHIS2 to another

``` 
./dhis2 orgunit copy --source https://user:password@dhis2_url
                     --destination https://user:password@dhis2_url
```

- Example copy from one instance to another

``` 
./dhis2 orgunit copy --source https://user:password@prod-dhis2.org
                     --destination https://user:password@test-dhis2.org
```

#Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BLSQ/dhis2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

#License

The gem is available as open source under the terms of the MIT License.

    
  
