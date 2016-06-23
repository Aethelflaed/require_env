# RequireEnv

Check environment variable presence easily.

## Install

`bundle install require_env`

## Usage

Create a YAML file, e.g. `config/environment.yml`, where you define the environment variables
required by your application, for the different environment it will run 
(test, development, production by default) 

- You can use ERB code to provide computed values
- You can use YAML defaults.
- An optional default value can be given for any key
- Keys ending with _IF_OTHER_VARIABLE will only be checked if OTHER_VARIABLE is defined and not equal 'false'
- Default value have precedence over the _IF_OTHER_VARIABLE rule

Here is an example presenting the different possibilities:

```yaml
DEFAULTS: &DEFAULTS
  BEANSTALK_URL: 'beanstalk://127.0.0.1'

  SLACK_TOKEN:

  # Use the environment variable TOKEN_SCALINGO as a default value if provided
  SCALINGO_TOKEN: "<%= ENV['TOKEN_SCALINGO'] %>"

  # Declare STRIPE_ENABLED to check for STRIPE_PUBLIC_KEY and STRIPE_SECRET_KEY
  STRIPE_PUBLIC_KEY_IF_STRIPE_ENABLED:
  STRIPE_SECRET_KEY_IF_STRIPE_ENABLED:

test:
  <<: *DEFAULTS
  IGNORE_EVENT_DELAY: 'true'

development:
  <<: *DEFAULTS
  IGNORE_EVENT_DELAY: 'true'

production:
  <<: *DEFAULTS
```

When your application starts, simply call `RequireEnv.check(Rails.root.join('config', 'environment.yml'))`
to check if the required environment variables are provided.

If any variable is missing, `RequireEnv::Missing` will be raised, detailing the missing environment variable.
