cookbooks-anyenv Cookbook
=========================
This cookbook install anyenv and \*env and specified language and versions


Attributes
----------

- `node[:anyenv][:location]` - インストールする場所 (user/global/custom)
  user - ユーザーvagrantで/home/vagrant/.anyenvにインストール。デフォルト
  global - ユーザーrootで/opt/anyenvにインストール
  custom - 任意のユーザー、任意の場所にインストール
- `node[:anyenv][:custom]` - `node[:anyenv][:location]`が'custom' の時のインストール情報
    - `node[:anyenv][:custom][:user]`    - インストールユーザ
    - `node[:anyenv][:custom][:prefix]`  - インストールprefixディレクトリ。ディレクトリは存在しなければならない。
    - `node[:anyenv][:custom][:dir]`     - インストールディレクトリ名 (インストール先= prefix/dir )
    - `node[:anyenv][:custom][:profile]` - シェルの設定ファイル。anyenvの起動時設定を書き込む。
- `node[:anyenv][(perl|ruby|node|python|php)]` - *env設定
	- `node[:anyenv][(perl|ruby|node|python|php)][:versions]` - install versions
	- `node[:anyenv][(perl|ruby|node|python|php)][:global]` - set to global version

Usage
-----

### cookbooks-anyenv::default

#### user install

```json
{
  "anyenv": {
  	"envs" => {
        "perl": {
          "versions":   ["5.18.1", "5.23.0"],
          "global":     "5.18.1"
        },
        "ruby": {
          "versions":   ["2.0.0-p353"],
          "global":     "2.0.0-p353"
        },
        "node": {
          "versions":  ["v0.10.17", "v0.12.6"],
          "global":    "v0.12.6"
        },
        "python": {
          "versions":   ["2.7.10", "3.4.3"],
          "global":     "3.4.3"
        },
        "php": {
          "versions":   ["5.4.42", "5.6.10"],
          "global":     "5.6.10"
        }
    }
  }
}
```

```bash
$ which anyenv
~/.anyenv/bin/anyenv
$ which rbenv
~/.anyenv/envs/rbenv/bin/rbenv
$ which ruby
~/.anyenv/envs/rbenv/shims/ruby
$ ruby --version
ruby 2.0.0p353 (2013-11-22 revision 43784) [x86_64-linux]
```


#### global install

```json
{
  "anyenv": {
    "location": "global",
    "envs": {
        "perl": {
          "versions":   ["5.18.1", "5.23.0"],
          "global":     "5.18.1"
        },
        "ruby": {
          "versions":   ["2.0.0-p353"],
          "global":     "2.0.0-p353"
        },
        "node": {
          "versions":  ["v0.10.17", "v0.12.6"],
          "global":    "v0.12.6"
        },
        "python": {
          "versions":   ["2.7.10", "3.4.3"],
          "global":     "3.4.3"
        },
        "php": {
          "versions":   ["5.4.42", "5.6.10"],
          "global":     "5.6.10"
        }
    }
  }
}
```

```bash
$ which anyenv
/opt/anyenv/bin/anyenv
$ which rbenv
/opt/anyenv/envs/rbenv/bin/rbenv
$ which ruby
/opt/anyenv/envs/rbenv/shims/ruby
$ ruby --version
ruby 2.0.0p353 (2013-11-22 revision 43784) [x86_64-linux]
```

Contributing
------------

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: koba04

The MIT License

Copyright (c) 2013 koba04

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


既知の問題
--------

rubyの古いバージョンをrbenvでインストールした際、以下のエラーが発生する。ruby-2.0.0-p353以上のバージョンであれば問題ない。


```bash
$ rbenv install 2.0.0-p247
Downloading yaml-0.1.6.tar.gz...
-> http://dqw8nmjcqpjn7.cloudfront.net/7da6971b4bd08a986dd2a61353bc422362bd0edcc67d7ebaac68c95f74182749
Installing yaml-0.1.6...
Installed yaml-0.1.6 to /home/vagrant/.anyenv/envs/rbenv/versions/2.0.0-p247

Downloading ruby-2.0.0-p247.tar.gz...
-> http://dqw8nmjcqpjn7.cloudfront.net/3e71042872c77726409460e8647a2f304083a15ae0defe90d8000a69917e20d3
Installing ruby-2.0.0-p247...

BUILD FAILED (CentOS Linux 7 using ruby-build 20150519-9-gae117b3)

Inspect or clean up the working tree at /tmp/ruby-build.20150612084116.18257
Results logged to /tmp/ruby-build.20150612084116.18257.log

Last 10 log lines:
                        ^
ossl_pkey_ec.c:821:29: error: ‘EC_GROUP_new_curve_GF2m’ undeclared (first use in this function)
                 new_curve = EC_GROUP_new_curve_GF2m;
                             ^
ossl_pkey_ec.c:821:29: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [ossl_pkey_ec.o] Error 1
make[2]: Leaving directory `/tmp/ruby-build.20150612084116.18257/ruby-2.0.0-p247/ext/openssl'
make[1]: *** [ext/openssl/all] Error 2
make[1]: Leaving directory `/tmp/ruby-build.20150612084116.18257/ruby-2.0.0-p247'
make: *** [build-ext] Error 2
```

参考：[CentOSのインストール手順に沿ってインストールするとサンプルが動作しない · Issue #4 · smalruby/smalruby](https://github.com/smalruby/smalruby/issues/4)


