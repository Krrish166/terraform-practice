terraform {
  backend "s3" {
    bucket = "dsfgsdvdfffffdfdfd"  #here bucket is name of s3 bucket
    key    = "terraform.tfstate"  #here key is path inside the bucket == you can direct file name or path name
    region = "ap-south-1"
    # s3 native locking  enabled 
    use_lockfile = true  #enables state locking to prevent concurrent operations
  }
}