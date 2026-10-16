import io.appium.java_client.AppiumBy;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.interactions.PointerInput;
import org.openqa.selenium.interactions.Sequence;
import org.testng.Assert;
import org.testng.annotations.Test;
import java.time.Duration;
import java.util.Collections;

public class MealDetailsTests extends BaseTest {
    private void scrollHome() {
        Dimension s = driver.manage().window().getSize();
        int x = s.width / 2;
        PointerInput finger = new PointerInput(PointerInput.Kind.TOUCH, "finger");
        Sequence swipe = new Sequence(finger, 1);
        swipe.addAction(finger.createPointerMove(Duration.ZERO, PointerInput.Origin.viewport(), x, (int)(s.height * .76)));
        swipe.addAction(finger.createPointerDown(PointerInput.MouseButton.LEFT.asArg()));
        swipe.addAction(finger.createPointerMove(Duration.ofMillis(600), PointerInput.Origin.viewport(), x, (int)(s.height * .35)));
        swipe.addAction(finger.createPointerUp(PointerInput.MouseButton.LEFT.asArg()));
        driver.perform(Collections.singletonList(swipe));
    }

    @Test(description = "AUTO-07 Open a Popular Meal from Home")
    public void openMealDetails() {
        ensureHome();

        // Only meal cards have a name and price in the same image accessibility label.
        // Category buttons (e.g. Chicken) and Hot Offers images do not have a price.
        By mealCard = AppiumBy.xpath("//android.widget.ImageView[contains(@content-desc,'$')]");
        WebElement card = null;
        for (int attempt = 0; attempt < 5 && card == null; attempt++) {
            for (WebElement candidate : driver.findElements(mealCard)) {
                if (candidate.isDisplayed()) { card = candidate; break; }
            }
            if (card == null) scrollHome();
        }
        Assert.assertNotNull(card, "No Popular Meals card was visible after scrolling Home.");
        String selectedMeal = card.getAttribute("content-desc");
        System.out.println("Opening Popular Meal: " + selectedMeal);
        card.click();

        // Details route has a quantity selector and Add to Cart button.

// Verify that the meal details page opened
By addToCart = AppiumBy.xpath(
    "//*[contains(@content-desc,'Add to Cart') " +
    "or contains(@text,'Add to Cart')]"
);

// Scroll down until Add to Cart is found
boolean found = false;

for (int i = 0; i < 5; i++) {
    if (!driver.findElements(addToCart).isEmpty()) {
        found = true;
        break;
    }

    driver.executeScript(
        "mobile: scrollGesture",
        java.util.Map.of(
            "left", 100,
            "top", 450,
            "width", 850,
            "height", 1400,
            "direction", "down",
            "percent", 0.65
        )
    );
}

Assert.assertTrue(
    found,
    "Meal details opened, but Add to Cart was not found."
);
        Assert.assertTrue(wait.until(d -> !d.findElements(addToCart).isEmpty()),
                "Popular Meal was tapped, but Meal Details/Add to Cart was not shown.");
        System.out.println("AUTO-07 PASS: Meal Details opened from Home.");
    }
}
