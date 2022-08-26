# Customized rule 

in this section, we gonna create some customized rule SonarQube

## Requirement

- [maven](https://www.baeldung.com/install-maven-on-windows-linux-mac)
- folder for build

## Build

you can build this source with steps
- move all files/folders on PHP-custom-rule
- you can modify in file S1.html/S2.html, MyPhpRulesTest.java.
- after you move and modify you can run the command for build file jar

```bash
mvn clean package
```

after the process build, you can find the file in the folder target. and you can place the file in $HOMEFOLDERSONARQUBE/extensions/plugins/.
