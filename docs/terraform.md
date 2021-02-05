## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attach\_network\_policy | Controls whether VPC/network policy should be added to IAM role for Lambda Function | `bool` | `false` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | n/a | yes |
| enabled | Set to false to prevent the module from creating any resources | `bool` | n/a | yes |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | n/a | yes |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | n/a | yes |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | n/a | yes |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | n/a | yes |
| lambda\_log\_level | The log level of the lambda function, one of CRITICAl, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
| lambda\_timeout\_seconds | The maximum time in seconds the lambda is allowed to run. | `number` | `300` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | n/a | yes |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | n/a | yes |
| python\_runtime\_version | lambda function runtime. the same version must be available in the controller's system PATH. | `string` | `"python3.7"` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | n/a | yes |
| secret\_prefix | The Secrets Manager secret prefix, including the wild card if you want one. e.g., 'foo-bar/ssh\_\*' | `string` | n/a | yes |
| server\_username | Username for the linux user used to login to the instances | `string` | `"admin"` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| tag\_name | Tag name to locate the instances which should be rotated | `string` | `"RotateSSHKeys"` | no |
| tag\_value | Tag value that must be set to locate the instances which should be rotated | `string` | `"true"` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_id | The VPC id that the lambda will be attached to | `string` | n/a | yes |
| vpc\_subnet\_ids | List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lambda | n/a |
| lambda\_arn | n/a |
| security\_group\_id | n/a |
| server\_username | n/a |
| tag\_name | n/a |
| tag\_value | n/a |

