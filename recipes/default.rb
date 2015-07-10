#
# Cookbook Name:: anyenv
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

location = node[:anyenv][:location]

user = node[:anyenv][location][:user]
prefix = node[:anyenv][location][:prefix]
dir = node[:anyenv][location][:dir]
profile = node[:anyenv][location][:profile]
anyenv_root="#{prefix}/#{dir}"


# install required packages
include_recipe "build-essential"
include_recipe "git"
include_recipe "yum-epel" if node[:platform_family] == 'rhel'

node[:anyenv][:requires].each do |p|
  package p do
    action :install
  end
end

# install anyenv
bash "anyenv" do
  user user
  environment "ANYENV_ROOT" => "#{anyenv_root}"
  code <<-EOC
    git clone https://github.com/riywo/anyenv #{anyenv_root}
    echo 'export ANYENV_ROOT=#{anyenv_root}' >> #{profile}
    echo 'export PATH="#{anyenv_root}/bin:$PATH"' >> #{profile}
    echo 'eval "$(anyenv init -)"' >> #{profile}
  EOC
  not_if { File.exist?("#{anyenv_root}") }
end

# install *env
anyenvs = %w{plenv ndenv rbenv pyenv phpenv}
anyenvs.each do |install_env|
  bash install_env do
    user user
    environment "ANYENV_ROOT" => "#{anyenv_root}"
    code <<-EOC
      export PATH="#{anyenv_root}/bin:$PATH"
      eval "$(anyenv init -)"
      anyenv install #{install_env}
    EOC
    not_if { File.exist?("#{anyenv_root}/envs/#{install_env}") }
  end
end

# install program
anyenv_map = {
  "perl" =>   "plenv",
  "ruby" =>   "rbenv",
  "node" =>   "ndenv",
  "python" => "pyenv",
  "php" =>    "phpenv",
}
anyenv_map.keys.each do |program|
  anyenv = node[:anyenv][:envs]
  next unless anyenv.key?(program)
  anyenv[program][:versions].each do |version|
    install_script = <<-EOC
      export PATH="#{anyenv_root}/bin:$PATH"
      eval "$(anyenv init -)"
      #{anyenv_map[program]} install #{version};
    EOC

    # set global
    install_script << "#{anyenv_map[program]} global #{version};" if version == anyenv[program][:global]

    bash "#{program} - #{version}" do
      user user
      environment "ANYENV_ROOT" => "#{anyenv_root}"
      code install_script
      not_if { File.exist?("#{anyenv_root}/envs/#{anyenv_map[program]}/versions/#{version}") }
    end
  end
end
