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

