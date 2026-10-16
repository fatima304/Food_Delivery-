import io.appium.java_client.AppiumBy;
import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.PointerInput;
import org.openqa.selenium.interactions.Sequence;
import org.testng.Assert;
import org.testng.annotations.Test;
import java.time.Duration;
import java.util.Collections;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class HomeAndCartTests extends BaseTest {
    private static final By CART_TAB = AppiumBy.xpath(
        "//android.widget.Button[contains(@content-desc,'Cart') and contains(@content-desc,'Tab 3')]");
    private static final By MEAL_CARD = AppiumBy.xpath(
        "//android.widget.ImageView[contains(@content-desc,'$')]");
    private static final By CART_ITEM = AppiumBy.xpath(
        "//android.widget.ImageView[contains(@content-desc,'$')]");

    private void swipeUp() {
        Dimension s = driver.manage().window().getSize();
        int x = s.width / 2;
        PointerInput finger = new PointerInput(PointerInput.Kind.TOUCH, "finger");
        Sequence swipe = new Sequence(finger, 1);
        swipe.addAction(finger.createPointerMove(Duration.ZERO,
                PointerInput.Origin.viewport(), x, (int)(s.height * .76)));
        swipe.addAction(finger.createPointerDown(PointerInput.MouseButton.LEFT.asArg()));
        swipe.addAction(finger.createPointerMove(Duration.ofMillis(650),
                PointerInput.Origin.viewport(), x, (int)(s.height * .33)));
        swipe.addAction(finger.createPointerUp(PointerInput.MouseButton.LEFT.asArg()));
        driver.perform(Collections.singletonList(swipe));
    }

    private void openCart() {
        Assert.assertTrue(visible(CART_TAB), "Cart tab not found");
        driver.findElement(CART_TAB).click();
        Assert.assertTrue(wait.until(d -> visible(CART)), "Cart page did not open");
    }

    private int cartItemCount() {
        return driver.findElements(CART_ITEM).size();
    }

    private int cartBadge() {
        for (WebElement e : driver.findElements(CART_TAB)) {
            String desc = e.getAttribute("content-desc");
            if (desc != null) {
                Matcher m = Pattern.compile("^(\\d+)\\s*\\nCart").matcher(desc);
                if (m.find()) return Integer.parseInt(m.group(1));
            }
        }
        return 0;
    }

    @Test(priority = 4, description = "AUTO-04 Home scroll")
    public void homeScroll() {
        ensureHome();
        String before = driver.getPageSource();
        swipeUp();
        String after = driver.getPageSource();
        Assert.assertNotEquals(after, before, "Home hierarchy did not change after scrolling");
    }

    @Test(priority = 5, description = "AUTO-05 Add available meal to cart")
    public void addMealToCart() {
        ensureHome();
        int before = cartBadge();
        // The home screen shows dynamic API meals. Do not hardcode Flan.
        for (int i = 0; i < 6 && !visible(MEAL_CARD); i++) swipeUp();
        Assert.assertTrue(visible(MEAL_CARD),
                "No priced Popular Meals card visible; check API/category and scroll position");
        WebElement card = driver.findElements(MEAL_CARD).get(0);
        String name = card.getAttribute("content-desc");
        // HomeMealCard uses a trailing clickable view for the plus icon.
        By add = AppiumBy.xpath("//android.widget.ImageView[contains(@content-desc,'$')]/android.view.View[@clickable='true']");
        Assert.assertTrue(visible(add), "Add (+) control missing from Popular Meals cards");
        driver.findElements(add).get(0).click();
        wait.until(d -> cartBadge() > before);
        openCart();
        Assert.assertTrue(cartItemCount() > 0,
                "Cart is empty after adding a meal: " + name);
    }
}
