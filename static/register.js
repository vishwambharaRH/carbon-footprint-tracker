document.addEventListener('DOMContentLoaded', () => {

    const registerForm = document.getElementById('register-form');
    const formMessage = document.getElementById('form-message');

    registerForm.addEventListener('submit', (event) => {
        event.preventDefault(); // Stop the form from reloading the page
        formMessage.textContent = ''; // Clear previous message

        // Get all the values from the form inputs
        const data = {
            user_id: document.getElementById('user-id').value,
            name: document.getElementById('name').value,
            email: document.getElementById('email').value,
            street: document.getElementById('street').value || null, // Send null if empty
            city: document.getElementById('city').value || null,
            state: document.getElementById('state').value || null
        };

        // Send this data to the new Flask API endpoint
        fetch('/api/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(response => {
            // We need to parse the JSON to read the message
            return response.json().then(result => {
                if (!response.ok) {
                    // If response is not 2xx, throw an error to be caught
                    throw new Error(result.error || 'An unknown error occurred.');
                }
                return result;
            });
        })
        .then(result => {
            // Handle success
            formMessage.textContent = result.message;
            formMessage.style.color = 'green';
            registerForm.reset(); // Clear the form
        })
        .catch(error => {
            // Handle errors (from fetch or non-ok response)
            console.error('Error:', error);
            formMessage.textContent = error.message;
            formMessage.style.color = 'red';
        });
    });
});