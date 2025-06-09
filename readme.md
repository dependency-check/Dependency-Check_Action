
# Welcome to Dependency check action

This action uses the docker image built every night in https://github.com/dependency-check/DependencyCheck_Builder. This image includes the updated vulnerabilities database so there is no need to update it. Therefore, it speeds up the test.

# What is Dependency-Check?

This action is based upon the OWASP Dependency-Check [tool](https://owasp.org/www-project-dependency-check/), a Software Composition Analysis (SCA) tool that attempts to detect publicly disclosed vulnerabilities contained within a project’s dependencies. It does this by determining if there is a Common Platform Enumeration (CPE) identifier for a given dependency. If found, it will generate a report linking to the associated CVE entries.

# How does it work?

The action has three required parameters:

- `project`: the project name
- `path`: the scanpath
- `format`: the report format

Additionally, you can specify:

- `out`: the output folder location relative to the github workspace, by default it will be `reports`
- `args`: any remaining flags and parameters to the binary, check the [arguments page](https://jeremylong.github.io/DependencyCheck/dependency-check-cli/arguments.html) for valid options

Example:
```

on: [push]

jobs:
  depchecktest:
    runs-on: ubuntu-latest
    name: depecheck_test
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Build project with Maven
        run: mvn clean install
      - name: Depcheck
        uses: dependency-check/Dependency-Check_Action@main
        id: Depcheck
        with:
          project: 'test'
          path: '.'
          format: 'HTML'
          out: 'reports' # this is the default, no need to specify unless you wish to override it
          args: >
            --failOnCVSS 7
            --enableRetired
      - name: Upload Test results
        uses: actions/upload-artifact@master
        with:
           name: Depcheck report
           path: ${{github.workspace}}/reports
```

### Error: JAVA_HOME is not defined correctly 
When used in conjunction with the GitHub Action [setup-java](https://github.com/actions/setup-java) you will see the error `Error: JAVA_HOME is not defined correctly`

This is due to the environment variable `JAVA_HOME` being changed by the setup-java GitHub Action. To fix this problem you will need to reset `JAVA_HOME` to match how it's being set in the image [Dependency-Check Docker Image](https://github.com/jeremylong/DependencyCheck/blob/main/Dockerfile#L16) within the Depcheck step. 

Example:
```yaml
...
- name: Depcheck
uses: dependency-check/Dependency-Check_Action@main
env:
  # actions/setup-java@v1 changes JAVA_HOME so it needs to be reset to match the depcheck image
  JAVA_HOME: /opt/jdk
...
```

# How Do I Use It?
We recommend adding the above example into your .github/workflows directory, using a name of your choice, in this example main.yml.

It should look like this

![](img/mainyml.png)

Once that action kicks off, you should be able to see it running in the actions tab.

![](img/actionrunning.png)

Finally, once it has completed, a report will be generated and accessible from the actions tab

![](img/report.png)

Downloading this and opening it in a browser will give you the following (for example)

![](img/output.png)

# Who Is Behind It?

Dependency check action was developed by the Santander UK Security Engineering team, namely:

- [Javier Domínguez Ruiz](https://github.com/javixeneize)
