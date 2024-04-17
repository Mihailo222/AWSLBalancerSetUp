<h1>AWS PROJECTS/Personal project - Using Terraform IaC tool for setting up AWS core infrastructure with two EC2 instances and Aplication Load Balancer</h1>

![Screenshot (1491)](https://github.com/Mihailo222/AWSLBalancerSetUp/assets/92820769/d428a1c2-8348-4fc7-8edf-15946098762a)

This is a basic AWS infrastructure setup, where we have EC2 instance configured to host files. <br/>

Firstly, I launched a **VPC** - **Virtual Private Cloud**. This is a logically isolated part of a internet where we can launch our own resources.

Inside a VPC I launched a **public subnet** - a range of IP addresses where we can launch resources into. Inside this subnet I launched **EC2** - a cloud virtual machine, so we can put anything on it (launch Kali Linux, Fedora, Ubuntu...)<br/>

We wrapped EC2 instance with **security group**. The security group is going to dictate **ingress and egress traffic**.<br/>

Our Virtual Machine needs to reach outside the outside of internet. How does it do that? Well, it's called **internet gateway**.<br/>

How does our virtual machine know where to go when reaching the internet - the **rout table** helps it.<br/>

I launched two public subnets in VPC with different availability zones to ensure high availability if one of the servers fails.<br>

The next concept used in this project is **Application Load Balancer**. It works on Layer 7 and introduces us to a concept of **microservice architecture**, where it comapres incoming packets based on their HTTP request. It's common sence HTTP requests are sent by HTTP methods (GET, HEAD, POST, PUT, DELETE and more) which are in charge of getting URL resources from a web environment. HTTP request comes from client  where the client sents a HTTP request based on wanted HTTP method when the HTTP request is generated. Application Load Balancer analyses HTTP requests in order to route a packet to a specific backend instance. It can rout packets based on hosts, paths and domains. For example, if a DevOps engineer is in charge of amazon.com, if he implements a ALB, he can project a solution for using microservice architecture. Why microservice architecture is better than monolit architecture? There is a lot of reasons: maintenance of a code distributed to more services is easier, testing is a lot easier, we can easily recognize an ownership of some code, better code revision, easier bug fixing and much more. So our DevOps engineer could easily split requests with loadbalancer - amazon.com/payments is a service for client's payments, amazon.com/transaction is a service for client's transactions and more. 

**ALB Implementation**: I created a resource - Application Load Balancer, wrapped it with Web Security Group I created, where I allowed all kinds of egress traffic from our VPC to internet and allowd only ingress trafic to port 80 (HTTP requests) to web server and SSH connections (port 22). The same practice is done to EC2 instances which need to bi accessible publicly to a internet and need to handle ingress traffic directly. In this setup we wanted boath EC2 instances - web sites to be accessible directly through internt. Of corse, if we want to achieve a more secured setup, we could configure EC2 instances to be launched in private subnets, ALB in public subnets and configure them to be accessible only via ALB which sends then requests.

**ALB target group** is a logical grouping of instances  (EC2 instances or containers), that ALB routes traffic to. Target groups are key component of ALB's routing functionallity, enabling load balancing, health checks and traffic distribution accross multiple targets. 
ALB is always sending **health checks** in order to check for EC2 instances connectivity. This is noting complex, but sending a HTTP GET request to the path provided, in our example its path http://<target_ip>/  and the port is traffic port which specifies that the health checks should be the same as the ALB routing port - I configured it to be port 80.

**ALB Listener** is a configuration component that defines how the ALB routes incoming traffic to the target groups associated within it. Listeners are responsble for inspecting incoming client requests and determininng how to forward them to the appropriate target groups based on the rules defined within the listener. **Port** - a listener is associated with a specific port on ALB. Clients send requests to this port, and the ALB listens for incoming traffic on that port (e.g. 80 for HTTP, 443 for HTTPS). **Rules** - listener may have one or more rules that defines how incoming requests are routed. Each rule consists of **condition and action**. Condition can include criteria such as request path, host header, or HTTP mthod. Action determines the action to be taken if a request maches the condition. **Default action** is an action defined on listener that specifies the action to be executed if none of the rule conditions are met. 

There can be some additional ALB concepts such as **SSL/TLS Termination** if connection to ALB is achieved via HTTPS. For HTTPS listeners, ALB can perform SSL/TLS termination, which means that the ALB decrypts incoming HTTPS requests, inspects the content, and then forwards the requests to the target group over HTTP. **Load Balancer Certificates** - HTTP listeners require SSL/TLS certificates to encrypt and decrypt traffic. ALB allows you to configure certificates for each listener, ensuring secure communication between clients with ALB.






