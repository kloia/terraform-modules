# terraform-s3-module

You can provision your S3 buckets on aws environment . 

## Supported Resources : 
* S3 buckets
* S3 lifecycle policies
* Archiving options 

You can check the vpc module from <a href="/main.tf"></a> . That is the simple usage of sqs module .


Usage : 

if `is_enabled` value is true, that create and enable lifescycle rules . LifeCycle Values is shown that below .

### LIFE CYCLE RULE VARIABLE TABLE
<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>is_enabled</td>
    <td>Default value is false, you must make it true for provide the lifecycle rules</td>
  </tr>

  <tr>
    <td>short_storage_day</td>
    <td>Short archiving period day</td>
  </tr>
  <tr>
    <td>storage_class</td>
    <td>Short archiving storage class</td>
  </tr>
  <tr>
    <td>long_storage_day</td>
    <td>Long archiving period day</td>
  </tr>
  <tr>
    <td>long_storage_class</td>
    <td>Long archiving storage class</td>
  </tr>
</table>


Terraform module implementation :

```terraform

module "my_s3_bucket" {
    source = "../../s3/"
    name = "access-privatet"
    acl = "private"
    tag_name = "tag1"
    tag_env = "tag1-env"
    versioning = true
    force_destroy = true ## disable/enable force destroy 
    is_enabled = true
    prefix = "log/" 
    life_cycle_id = "log"
}
```