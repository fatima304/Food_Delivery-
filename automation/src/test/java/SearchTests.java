import io.appium.java_client.AppiumBy;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.testng.Assert;
import org.testng.annotations.Test;
import java.time.Duration;
import org.openqa.selenium.support.ui.WebDriverWait;

public class SearchTests extends BaseTest {
    @Test(description = "AUTO-06 Search for a meal")
    public void searchForMeal() {
        ensureHome();
        // The Home search field is read-only and opens the Search screen.
        By homeSearch = AppiumBy.xpath("//*[@hint='Search for meals or vendors']");
        Assert.assertTrue(wait.until(d -> !d.findElements(homeSearch).isEmpty()),
                "Home search field was not found. Set app language to English.");
        driver.findElement(homeSearch).click();

        By searchInput = AppiumBy.className("android.widget.EditText");
        WebElement field = wait.until(d -> {
            for (WebElement element : d.findElements(searchInput)) {
                if (element.isDisplayed()) return element;
            }
            return null;
        });
        field.click();
        field.sendKeys("Chicken");
        try { driver.hideKeyboard(); } catch (Exception ignored) { }

        // SearchCubit searches asynchronously; wait for an actual matching meal card.
        WebDriverWait resultsWait = new WebDriverWait(driver, Duration.ofSeconds(35));
        boolean found = resultsWait.until(d -> {
            String page = d.getPageSource().toLowerCase();
            return page.contains("chicken") &&
                   (page.contains("chicken handi") || page.contains("chicken alfredo") ||
                    page.contains("chicken curry") || page.contains("chicken") &&
                    d.findElements(AppiumBy.xpath("//*[contains(translate(@content-desc,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'chicken')]")).size() > 0);
        });
        Assert.assertTrue(found, "No matching Chicken meal found in search results.");
    }
}
