<h1>AWS PROJECTS/Personal project - Using Terraform IaC tool for setting up AWS core infrastructure with two EC2 instances and Aplication Load Balancer</h1>

![Screenshot (1491)](https://github.com/Mihailo222/AWSLBalancerSetUp/assets/92820769/d428a1c2-8348-4fc7-8edf-15946098762a)

This is a basic AWS infrastructure setup, where we have EC2 instance configured to host files. <br/>

Firstly, I launched a **VPC** - **Virtual Private Cloud**. This is a logically isolated part of a internet where we can launch our own resources.

Inside a VPC I launched a **public subnet** - a range of IP addresses where we can launch resources into. Inside this subnet I launched **EC2** - a cloud virtual machine, so we can put anything on it (launch Kali Linux, Fedora, Ubuntu...)<br/>

We wrapped EC2 instance with **security group**. The security group is going to dictate **ingress and egress traffic**.<br/>

Our Virtual Machine needs to reach outside the outside of internet. How does it do that? Well, it's called **internet gateway**.<br/>

How does our virtual machine know where to go when reaching the internet - the **rout table** helps it.<br/>

I launched two public subnets in VPC with different availability zones to ensure high availability if one of the servers fails.<br>
 ************

Can we upgrade this project? Yes, by adding AWS virtual firewalls and other AWS monitoring tools used in following projects. <br/>



