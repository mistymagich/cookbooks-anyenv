#
# Cookbook Name:: anyenv
# Attributes:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# Licensed under the MIT license
#


# インストールする場所
# user - ユーザー権限で指定の場所
# global - root権限で指定の場所
# custom - カスタム
default[:anyenv][:location] = 'user'


#
# インストールする場所別各種定義
#
default[:anyenv][:global] = {
  user: 'root',
  prefix: '/opt',
  dir: 'anyenv',
  profile: '/etc/profile.d/anyenv.sh'
}

default[:anyenv][:user] = {
  user: 'vagrant',
  prefix: '/home/vagrant',
  dir: '.anyenv',
  profile: '/home/vagrant/.bash_profile' 
}

default[:anyenv][:custom] = {
  user: nil,
  prefix: nil, 
  dir: nil,
  profile: nil
}


#
# 各envでインストールするバージョンとglobalでセットするバージョン
#
default[:anyenv][:envs] = {};


#
# プラットフォーム別依存パッケージ
#
case node['platform_family']
when 'rhel'
  default[:anyenv][:requires] = %w(openssl-devel readline-devel bzip2-devel sqlite-devel libxml2-devel libcurl-devel libjpeg-turbo-devel libpng-devel libmcrypt-devel libtidy-devel libxslt-devel)
when 'debian'
  default[:anyenv][:requires] = %w(libssl-dev libreadline-dev libbz2-dev libsqlite3-dev libxml2-dev libcurl4-openssl-dev libjpeg-dev libpng12-dev libmcrypt-dev libtidy-dev libxslt1-dev re2c)
end
