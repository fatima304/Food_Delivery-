import org.testng.Assert;
import org.testng.annotations.Test;

public class LoginTests extends BaseTest {
    @Test(priority = 1, description = "AUTO-03 Empty login")
    public void emptyLogin() {
        openLogin();
        fillLogin("", "");
        tapSignIn();
        Assert.assertTrue(visible(LOGIN), "Empty credentials should stay on Login");
    }

    @Test(priority = 2, description = "AUTO-02 Invalid login")
    public void invalidLogin() {
        openLogin();
        fillLogin("invalid_user@example.com", "WrongPassword123!");
        tapSignIn();
        Assert.assertTrue(wait.until(d -> visible(LOGIN)),
                "Invalid credentials should stay on Login");
    }

    @Test(priority = 3, description = "AUTO-01 Valid login")
    public void validLogin() {
        openLogin();
        fillLogin(requiredEnv("TEST_EMAIL"), requiredEnv("TEST_PASSWORD"));
        tapSignIn();
        Assert.assertTrue(wait.until(d -> visible(HOME)),
                "Valid login should navigate to Home Screen");
    }
}
