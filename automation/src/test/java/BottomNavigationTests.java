import io.appium.java_client.AppiumBy;
import org.openqa.selenium.By;
import org.testng.Assert;
import org.testng.annotations.Test;

public class BottomNavigationTests extends BaseTest {
    @Test(description = "AUTO-08 Bottom navigation: Home -> Cart -> Home")
    public void bottomNavigation() {
        ensureHome();
        By cartTab = AppiumBy.xpath("//android.widget.Button[contains(@content-desc,'Cart') and contains(@content-desc,'Tab 3')]");
        By homeTab = AppiumBy.xpath("//android.widget.Button[contains(@content-desc,'Home') and contains(@content-desc,'Tab 1')]");
        wait.until(d -> d.findElement(cartTab)).click();
        Assert.assertTrue(wait.until(d -> visible(CART)), "Cart screen did not open");
        wait.until(d -> d.findElement(homeTab)).click();
        Assert.assertTrue(wait.until(d -> visible(HOME)), "Home screen did not open again");
    }
}
