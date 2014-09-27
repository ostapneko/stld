#!/usr/bin/env ruby
require_relative '../config/connection'

Sequel.extension :migration

migration_dir = File.join(File.dirname(__FILE__), '..', 'migrations')

Sequel::Migrator.run(DB, migration_dir)
