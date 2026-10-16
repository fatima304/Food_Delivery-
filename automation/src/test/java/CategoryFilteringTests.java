
import io.appium.java_client.AppiumBy;
import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.interactions.PointerInput;
import org.openqa.selenium.interactions.Sequence;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.time.Duration;
import java.util.Collections;
import java.util.Map;

public class CategoryFilteringTests extends BaseTest {

    private static final By CARDS = AppiumBy.xpath(
        "//android.widget.ImageView[contains(@content-desc,'$')]"
    );

    private void swipeUp() {
        Dimension s = driver.manage().window().getSize();
        int x = s.width / 2;

        PointerInput finger = new PointerInput(
            PointerInput.Kind.TOUCH, "finger"
        );

        Sequence sequence = new Sequence(finger, 1);

        sequence.addAction(finger.createPointerMove(
            Duration.ZERO,
            PointerInput.Origin.viewport(),
            x,
            (int) (s.height * 0.75)
        ));

        sequence.addAction(finger.createPointerDown(
            PointerInput.MouseButton.LEFT.asArg()
        ));

        sequence.addAction(finger.createPointerMove(
            Duration.ofMillis(600),
            PointerInput.Origin.viewport(),
            x,
            (int) (s.height * 0.37)
        ));

        sequence.addAction(finger.createPointerUp(
            PointerInput.MouseButton.LEFT.asArg()
        ));

        driver.perform(Collections.singletonList(sequence));
    }

    private String firstMeal() {

        for (int i = 0; i < 6 && !visible(CARDS); i++) {
            swipeUp();
        }

        WebDriverWait mealWait = new WebDriverWait(
            driver, Duration.ofSeconds(20)
        );

        mealWait.ignoring(StaleElementReferenceException.class);

        String meal = mealWait.until(d -> {

            if (d.findElements(CARDS).isEmpty()) {
                return null;
            }

            String description = d.findElements(CARDS)
                .get(0)
                .getAttribute("content-desc");

            if (description == null || description.isBlank()) {
                return null;
            }

            return description;
        });

        Assert.assertNotNull(meal, "No Popular Meals loaded");

        return meal;
    }

    private void scrollToCategories() {

        By all = AppiumBy.accessibilityId("All");

        for (int i = 0; i < 6 && !visible(all); i++) {

            driver.executeScript(
                "mobile: scrollGesture",
                Map.of(
                    "left", 80,
                    "top", 300,
                    "width", 900,
                    "height", 1500,
                    "direction", "down",
                    "percent", 0.7
                )
            );
        }

        Assert.assertTrue(
            visible(all),
            "All category not found when returning to filters"
        );
    }

    @Test(description = "AUTO-10 Filter Home meals by category")
    public void categoryFiltering() {

        ensureHome();

        By chicken = AppiumBy.accessibilityId("Chicken");

        Assert.assertTrue(
            wait.until(d -> visible(chicken)),
            "Chicken category missing"
        );

        driver.findElement(chicken).click();

        String filtered = firstMeal();

        Assert.assertFalse(
            filtered.isBlank(),
            "No meals shown after selecting Chicken"
        );

        System.out.println(
            "Category Chicken first result: " + filtered
        );

        scrollToCategories();

        By all = AppiumBy.accessibilityId("All");

        driver.findElement(all).click();

        String restored = firstMeal();

        Assert.assertFalse(
            restored.isBlank(),
            "Popular Meals missing after clearing filter"
        );

        System.out.println(
            "AUTO-10 PASS: Category filtering and reset."
        );
    }
}
