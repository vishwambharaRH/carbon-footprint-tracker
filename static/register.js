// This 'DOMContentLoaded' waits for the HTML page to be
// fully loaded before running any JavaScript.
document.addEventListener('DOMContentLoaded', () => {

    const registerForm = document.getElementById('register-form');
    const formMessage = document.getElementById('form-message');

    registerForm.addEventListener('submit', (event) => {
        event.preventDefault(); // Stop the form from reloading the page

        // Get all the values from the registration form
        const data = {
            user_id: document.getElementById('user-id').value,
            name: document.getElementById('name').value,
            email: document.getElementById('email').value,
            street: document.getElementById('street').value,
            city: document.getElementById('city').value,
            state: document.getElementById('state').value
        };

        // Send this data to the NEW Flask API endpoint '/register'
        fetch('/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(result => {
            if (result.error) {
                // Show an error if something went wrong (e.g., user ID taken)
                formMessage.style.color = 'red';
                formMessage.textContent = result.error;
            } else {
                // Show a success message
                formMessage.style.color = 'green';
                formMessage.textContent = result.message;
                registerForm.reset(); // Clear the form
            }
        })
        .catch(error => {
            console.error('Error:', error);
            formMessage.style.color = 'red';
            formMessage.textContent = 'An error occurred. Please try again.';
        });
    });
});