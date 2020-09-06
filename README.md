<!-- 














  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated by the `build-harness`. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **















  -->

# terraform-aws-lambda-secrets-manager-ssh-key-rotation




This is a terraform module that creates a lambda function that rotates SSH keys
on EC2 instances via AWS Secrets Manager.


---


This project is part of the [Guardian Project Ops](https://gitlab.com/guardianproject-ops/) collection.







It's free and open source made available under the the [GNU Affero General Public v3 License](LICENSE.md).




## Introduction


This module is based off the AWS example:

  * [How to use AWS Secrets Manager to securely store and rotate SSH key pairs](https://aws.amazon.com/blogs/security/how-to-use-aws-secrets-manager-securely-store-rotate-ssh-key-pairs/)

The original source is from
[aws-samples/aws-secrets-manager-ssh-key-rotation](https://github.com/aws-samples/aws-secrets-manager-ssh-key-rotation)
and it is (C) Amazon and licensed under MIT-0.



## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/releases).



Note that `master` is used in the examples, but you should instead pin to the latest tag.

```hcl
module "rotate_ssh" {
  source          = "git::https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation.git?ref=tags/master"

  namespace       = var.namespace
  name            = var.name
  stage           = var.stage
  delimiter       = var.delimiter
  attributes      = ["ssh-key-rotate"]
  tags            = var.tags
  server_username = "admin"
  tag_name        = "RotateSSHKeys"
  tag_value       = "true"
}
```






## Providers

| Name | Version |
|------|---------|
| archive | ~> 1.3.0 |
| aws | ~> 2.0 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| attributes | Additional attributes (e.g., `one', or `two') | `list` | `[]` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | `string` | `"-"` | no |
| name | Name  (e.g. `app` or `database`) | `string` | n/a | yes |
| namespace | Namespace, your org | `string` | n/a | yes |
| server\_username | Username for the linux user used to login to the instances | `string` | `"admin"` | no |
| stage | Environment (e.g. dev, prod, test) | `string` | n/a | yes |
| tag\_name | Tag name to locate the instances which should be rotated | `string` | `"RotateSSHKeys"` | no |
| tag\_value | Tag value that must be set to locate the instances which should be rotated | `string` | `"true"` | no |
| tags | Additional tags (e.g. map(`Visibility`,`Public`) | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda | the lambda resource output |
| server\_username | n/a |
| tag\_name | n/a |
| tag\_value | n/a |





## Help

File an [issue](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/issues), send us an [email][email] or join us in the Matrix 'verse at [#guardianproject:matrix.org][matrix] or IRC at `#guardianproject` on Freenode.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/issues) to report any bugs or file feature requests.

### Developing

If you are interested in becoming a contributor, want to get involved in
developing this project, other projects, or want to [join our team][join], we
would love to hear from you! Shoot us an [email][join-email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitLab
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Merge Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

## Credits & License 


Copyright © 2017-2020 [Guardian Project][website]












[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0.en.html)

    GNU AFFERO GENERAL PUBLIC LICENSE
    Version 3, 19 November 2007

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.


See [LICENSE.md](LICENSE.md) for full details.

## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

**This project is maintained and funded by [The Guardian Project][website].**

[<img src="https://gitlab.com/guardianproject/guardianprojectpublic/-/raw/master/Graphics/GuardianProject/pngs/logo-black-w256.png"/>][website]

We're a [collective of designers and developers][website] focused on useable
privacy and security. Everything we do is 100% FOSS. Check out out other [ops
projects][gitlab] and [non-ops projects][nonops], follow us on
[mastadon][mastadon] or [twitter][twitter], [apply for a job][join], or
[partner with us][partner].




### Contributors

|  [![Abel Luck][abelxluck_avatar]][abelxluck_homepage]<br/>[Abel Luck][abelxluck_homepage] |
|---|

  [abelxluck_homepage]: https://gitlab.com/abelxluck

  [abelxluck_avatar]: https://secure.gravatar.com/avatar/0f605397e0ead93a68e1be26dc26481a?s=100&amp;d=identicon





[logo-square]: https://assets.gitlab-static.net/uploads/-/system/group/avatar/3262938/guardianproject.png?width=88
[logo]: https://guardianproject.info/GP_Logo_with_text.png
[join]: https://guardianproject.info/contact/join/
[website]: https://guardianproject.info
[cdr]: https://digiresilience.org
[cdr-tech]: https://digiresilience.org/tech/
[matrix]: https://riot.im/app/#/room/#guardianproject:matrix.org
[join-email]: mailto:jobs@guardianproject.info
[email]: mailto:support@guardianproject.info
[cdr-email]: mailto:info@digiresilience.org
[twitter]: https://twitter.com/guardianproject
[mastadon]: https://social.librem.one/@guardianproject
[gitlab]: https://gitlab.com/guardianproject-ops
[nonops]: https://gitlab.com/guardianproject
[partner]: https://guardianproject.info/how-you-can-work-with-us/
