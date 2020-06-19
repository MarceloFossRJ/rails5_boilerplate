# Rails 5 Boilerplate
Creates a new Rails multi-tenant app using pre-defined defaults, using rails templates approach [https://guides.rubyonrails.org/rails_application_templates.html](https://guides.rubyonrails.org/rails_application_templates.html).

Tested Rails Version:
`gem 'rails', '~> 5.2.1'`
`gem 'rails', '~> 5.2.3'`

Test Ruby Versions:
`ruby '2.6.1'`
`ruby '2.7.0'`

## How to use
To apply a template, you need to provide the Rails generator with the location of the template you wish to apply using the -m option. This can either be a path to a file or a URL.

```bash
$ rails new myapp -d <postgresql, mysql, sqlite> -m ~/template.rb
$ rails new myapp -d <postgresql, mysql, sqlite> -m http://example.com/boilerplate.rb
```
You can use the `app:template` rails command to apply templates to an existing Rails application. The location of the template needs to be passed in via the LOCATION environment variable. Again, this can either be path to a file or a URL.

```bash
$ rails app:template LOCATION=~/template.rb
$ rails app:template LOCATION=http://example.com/template.rb
```
