Copy three .java files into automation/src/test/java/ and three .xml files into automation/. Keep your existing BaseTest.java, pom.xml and testng.xml unchanged. Run separately:
mvn clean test "-Dsurefire.suiteXmlFiles=navigation-testng.xml"
mvn clean test "-Dsurefire.suiteXmlFiles=remove-testng.xml"
mvn clean test "-Dsurefire.suiteXmlFiles=category-testng.xml"
Precondition: signed in, Home, English, internet enabled. Remove test modifies cart. These tests are not yet validated on the physical device.
