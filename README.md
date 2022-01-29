## Assignment #2
### Goal of the assignment:
```
Design and implement a pipeline that will deploy, expose and manage application(having web,API part and DB) in OpsWorks stack and its instances.
As a result of the assignment we should be able to deploy, manage stack and instance state and access created resources. We would like to also be able to review code for it.
Ensure code is maintainable and readable. Include hand-over notes.
We believe in minimal effort for maximum result, so smart usage of existing solutions is welcome.
Our stack is Terraform, Kubernetes, Helm, Docker, OpsWorks, ELK, Jenkins, but experience with or usage of other tools/technologies is always welcome
Please fork this repository for application code: https://github.com/gbulanov/node-3tier-app/
```
 *Provided along with the instructions:*
  1. aws account console login URL
  2. aws credentials with admin access
  3. slack chanel ID for communications

### **Details**
  + Infrastructure deployment (total 40 points)
    - 5 points    - OpsWorks stack/layers and DB of your choice are deployed in non-default VPC in **eu-west-1** region using terraform
    - 10 points   - Stack is deployed with instances in preferred (controlled from code/pipeline) state
    - 10 points   - Stack settings and config are created/managed from Terraform
    - 5 points    - Instance(s) should have external storage that is persisted on instance re-launch and re-create.
    - 10 points   - Chef cookbook(s) are configuring instances
  + Application deployment (total 25 points)
    - 10 points   - Integrate application deployment into Chef cookbook(s)
    - 5 points    - Application can be accessed via externally-available URL
    - 10 points   - Application is (re)-built and (re)-deployed, on commit, via CD pipeline
  + Additional (total 15 points):
    - 5 points    - include hand-over notes and describe best practices for chef cookbooks
    - 5 points    - suggest logging/monitoring solutions for the above solution
    - 5 points    - Implement logging of your choice, using tools/technologies of your choice


### **How To:**

```
terraform init
terraform <plan/apply> -var 'db_username=foo' -var 'db_password=<CHANGEIT>'
```
Obs.: This values should come from a pipeline CI/CD