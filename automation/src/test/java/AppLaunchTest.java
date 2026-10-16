import org.testng.Assert;
import org.testng.annotations.Test;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class AppLaunchTest extends BaseTest {

    @Test
    public void testAppLaunch() {

        driver.activateApp("com.example.food_delivery");

        WebDriverWait wait = new WebDriverWait(
                driver, Duration.ofSeconds(20));

        boolean appOpened = wait.until(d ->
                "com.example.food_delivery"
                        .equals(driver.getCurrentPackage()));

        Assert.assertTrue(appOpened,
                "StreetBite should be the foreground app");

        System.out.println("StreetBite launched successfully!");
    }
}
