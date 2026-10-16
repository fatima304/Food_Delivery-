import io.appium.java_client.AppiumBy;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.options.UiAutomator2Options;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.SkipException;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import java.net.URL;
import java.time.Duration;

public class BaseTest {
    protected AndroidDriver driver;
    protected WebDriverWait wait;
    protected static final String PACKAGE = "com.example.food_delivery";
    protected static final By LOGIN = AppiumBy.accessibilityId("Welcome back");
    protected static final By HOME = AppiumBy.accessibilityId("Home Screen");
    protected static final By CART = AppiumBy.accessibilityId("My Cart");

    @BeforeMethod
    public void setUp() throws Exception {
        UiAutomator2Options options = new UiAutomator2Options();
        options.setDeviceName("105f06a");
        options.setUdid("105f06a");
        options.setAutomationName("UiAutomator2");
        options.setAppPackage(PACKAGE);
        options.setAppActivity("com.example.food_delivery.MainActivity");
        options.setNoReset(true);
        driver = new AndroidDriver(new URL("http://127.0.0.1:4723"), options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));
        wait = new WebDriverWait(driver, Duration.ofSeconds(20));
        driver.activateApp(PACKAGE);
        wait.until(d -> PACKAGE.equals(driver.getCurrentPackage()));
    }

    protected boolean visible(By locator) {
        return !driver.findElements(locator).isEmpty();
    }

    protected void openLogin() {
        if (visible(LOGIN)) return;
        if (visible(HOME) || visible(CART)) {
            Assert.fail("PRECONDITION: Sign out from Profile, then open Login before running the full suite.");
        }
        // Onboarding navigation: first try the direct Sign In link.
        By directLink = AppiumBy.xpath("//*[@content-desc='Already have an account? Sign In' or @content-desc='Sign In']");
        if (visible(directLink)) driver.findElement(directLink).click();
        else {
            By getStarted = AppiumBy.accessibilityId("Get Started");
            if (visible(getStarted)) driver.findElement(getStarted).click();
            By signIn = AppiumBy.xpath("//*[contains(@content-desc,'Sign In')]");
            if (visible(signIn)) driver.findElement(signIn).click();
        }
        Assert.assertTrue(wait.until(d -> visible(LOGIN)),
                "Login screen not found. Open Login manually before running login tests.");
    }

    protected void fillLogin(String email, String password) {
        // Flutter removes the hint after typing, so locate both fields by order.
        By fields = AppiumBy.className("android.widget.EditText");
        wait.until(d -> d.findElements(fields).size() >= 2);
        WebElement emailField = driver.findElements(fields).get(0);
        emailField.click();
        emailField.clear();
        if (!email.isEmpty()) emailField.sendKeys(email);

        // Re-query after entering text because Flutter can rebuild its widgets.
        wait.until(d -> d.findElements(fields).size() >= 2);
        WebElement passwordField = driver.findElements(fields).get(1);
        passwordField.click();
        passwordField.clear();
        if (!password.isEmpty()) passwordField.sendKeys(password);
        try { driver.hideKeyboard(); } catch (Exception ignored) { }

        // Check the same field, not its hint (which disappears after input).
        if (!email.isEmpty()) {
            String actual = driver.findElements(fields).get(0).getText();
            Assert.assertTrue(actual.contains(email),
                    "Email field did not retain typed text. Actual=" + actual);
        }
    }

    protected void tapSignIn() {
        driver.findElement(AppiumBy.accessibilityId("Sign In")).click();
    }

    protected String requiredEnv(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank())
            throw new SkipException("Set " + name + " in PowerShell before running this test.");
        return value;
    }

protected void ensureHome() {
    if (visible(HOME)) return;

    By homeTab = AppiumBy.xpath(
        "//android.widget.Button[" +
        "contains(@content-desc,'Home') and " +
        "contains(@content-desc,'Tab 1')" +
        "]"
    );

    // Return to Home using bottom navigation.
    if (visible(homeTab)) {
        driver.findElement(homeTab).click();
    }

    // If we are on a screen without bottom navigation,
    // try going back to the main screen.
    for (int i = 0; i < 3 && !visible(HOME); i++) {

        if (visible(homeTab)) {
            driver.findElement(homeTab).click();
            break;
        }

        if (visible(LOGIN)) {
            fillLogin(
                requiredEnv("TEST_EMAIL"),
                requiredEnv("TEST_PASSWORD")
            );
            tapSignIn();
            break;
        }

        driver.navigate().back();
    }

    Assert.assertTrue(
        wait.until(d -> visible(HOME)),
        "Home not found after navigation."
    );
}

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        if (driver != null) driver.quit();
    }
}
