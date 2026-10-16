
import io.appium.java_client.AppiumBy;
import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.interactions.PointerInput;
import org.openqa.selenium.interactions.Sequence;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.time.Duration;
import java.util.Collections;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RemoveFromCartTests extends BaseTest {

    private static final By CART_TAB = AppiumBy.xpath(
            "//android.widget.Button[contains(@content-desc,'Cart') and contains(@content-desc,'Tab 3')]");

    private static final By MEAL_CARDS = AppiumBy.xpath(
            "//android.widget.ImageView[contains(@content-desc,'$')]");

    private static final By ADD = AppiumBy.xpath(
            "//android.widget.ImageView[contains(@content-desc,'$')]/android.view.View[@clickable='true']");

    private void swipeUp() {
        Dimension s = driver.manage().window().getSize();
        int x = s.width / 2;

        PointerInput finger = new PointerInput(
                PointerInput.Kind.TOUCH, "finger");

        Sequence seq = new Sequence(finger, 1);

        seq.addAction(finger.createPointerMove(
                Duration.ZERO,
                PointerInput.Origin.viewport(),
                x,
                (int) (s.height * 0.76)));

        seq.addAction(finger.createPointerDown(
                PointerInput.MouseButton.LEFT.asArg()));

        seq.addAction(finger.createPointerMove(
                Duration.ofMillis(600),
                PointerInput.Origin.viewport(),
                x,
                (int) (s.height * 0.35)));

        seq.addAction(finger.createPointerUp(
                PointerInput.MouseButton.LEFT.asArg()));

        driver.perform(Collections.singletonList(seq));
    }

    private int quantity(String desc) {
        Matcher m = Pattern.compile("(?m)^(\\d+)$").matcher(desc);
        return m.find() ? Integer.parseInt(m.group(1)) : -1;
    }

    @Test(description = "AUTO-09 Remove meal from cart")
    public void removeFromCart() {

        ensureHome();

        for (int i = 0; i < 6 && !visible(ADD); i++) {
            swipeUp();
        }

        Assert.assertTrue(
                visible(ADD),
                "No Popular Meals add button found");

        String mealName = driver.findElements(MEAL_CARDS)
                .get(0)
                .getAttribute("content-desc")
                .split("\n")[0];

        driver.findElements(ADD).get(0).click();

        wait.until(d -> visible(CART_TAB));
        driver.findElement(CART_TAB).click();

        Assert.assertTrue(
                wait.until(d -> visible(CART)),
                "Cart not opened");

        By item = AppiumBy.xpath(
                "//android.widget.ImageView[starts-with(@content-desc,'" +
                        mealName.replace("'", "") + "')]");

        Assert.assertTrue(
                wait.until(d -> visible(item)),
                "Added meal not found in Cart: " + mealName);

        String desc = driver.findElement(item)
                .getAttribute("content-desc");

        int qty = quantity(desc);

        Assert.assertTrue(
                qty > 0 && qty <= 30,
                "Unexpected item quantity: " + desc);

        for (int i = 0; i < qty; i++) {

            By minusButton = AppiumBy.xpath(
                    "//android.widget.ImageView[" +
                            "starts-with(@content-desc,'" + mealName.replace("'", "") + "')" +
                            "]/android.widget.Button[1]");

            driver.findElement(minusButton).click();

            if (i < qty - 1) {
                final int expected = qty - i - 1;

                wait.until(d -> visible(item) &&
                        quantity(
                                d.findElement(item)
                                        .getAttribute("content-desc")) == expected);
            }
        }

        Assert.assertTrue(
                wait.until(d -> !visible(item)),
                "Meal still present after decreasing to zero");
    }
}
