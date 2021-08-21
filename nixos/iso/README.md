# NixOS ISO builder

Automatically makes a NixOS ISO with useful stuff for easy remote/automated install. This uses Makefile because why not.

To create the ISO, run
```
make 
```

To spawn a testing environment for the ISO using Libvirt and Terraform, run
```
make test
````

To destroy just your testing environment and nothing else, run
```
make clean-test
```

To clean everything up, run
```
make clean
```