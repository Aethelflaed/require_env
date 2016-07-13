require 'test_helper'

class RequireEnvTest < ActiveSupport::TestCase
  setup do
    ENV.delete('RAILS_ENV')
    ENV.delete('VAR')
    ENV.delete('SUM')
    ENV.delete('FOO')
    ENV.delete('BAR')
    ENV.delete('BAZ')
  end

  test 'truth' do
    assert_kind_of Module, RequireEnv
  end

  test 'check' do
    file = File.expand_path('../test.yml', __FILE__)

    RequireEnv.application_environment = nil
    assert_raise(ArgumentError) do
      RequireEnv.check(file, file)
    end

    ENV['RAILS_ENV'] = 'test'
    assert_raise(RequireEnv::Missing) do
      RequireEnv.check(file)
    end

    ENV['FOO'] = 'bar'
    RequireEnv.check(file)
  end

  test 'application_environment' do
    ENV['RAILS_ENV'] = 'test'
    assert_equal 'test', RequireEnv.application_environment

    ENV['RAILS_ENV'] = 'foo'
    assert_equal 'test', RequireEnv.application_environment

    RequireEnv.application_environment = 'whatever'
    assert_equal 'whatever', RequireEnv.application_environment
  end

  test 'requirements_from_file' do
    assert_raise(ArgumentError) do
      RequireEnv.requirements_from_file('foobar')
    end

    file = File.expand_path('../test.yml', __FILE__)
    result = RequireEnv.requirements_from_file(file)

    assert_kind_of Hash, result
    assert_equal 'foo', result.dig('test', 'VAR')
    assert_equal 2, result.dig('test', 'SUM')
    assert_equal nil, result.dig('test', 'FOO')
  end

  test 'check_requirements' do
    requirements = {
      'VAR' => nil,
      'FOO' => 'BAR',
      'BAR_IF_CONDITION' => nil,
    }

    missing = RequireEnv.check_requirements(requirements)
    assert_equal ['VAR'], missing
    assert_equal 'BAR', ENV['FOO']

    ENV['CONDITION'] = 'false'
    ENV['VAR'] = 'bla'
    missing = RequireEnv.check_requirements(requirements)

    ENV['CONDITION'] = 'foo'
    missing = RequireEnv.check_requirements(requirements)
    assert_equal ['BAR'], missing
  end

  test 'check_multiple_requirements' do
    multiple_requirements = {
      'foo.yml' => {
        'VAR' => nil,
        'FOO' => 'BAR',
      },
      'bar.yml' => {
        'BAR' => nil,
        'BAZ' => nil,
      },
    }

    ENV['BAR'] = 'test'

    assert_raise(RequireEnv::Missing) do
      RequireEnv.check_multiple_requirements(multiple_requirements)
    end
    ENV['BAZ'] = 'test'
    assert_raise(RequireEnv::Missing) do
      RequireEnv.check_multiple_requirements(multiple_requirements)
    end
    ENV['VAR'] = 'bla'
  end
end
