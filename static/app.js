// This 'DOMContentLoaded' waits for the HTML page to be
// fully loaded before running any JavaScript.
document.addEventListener('DOMContentLoaded', () => {

    // --- 1. HANDLE THE "LOG ACTIVITY" FORM ---
    
    // Get the form element from the HTML
    const logForm = document.getElementById('log-form');
    const formMessage = document.getElementById('form-message');

    logForm.addEventListener('submit', (event) => {
        event.preventDefault(); // Stop the form from reloading the page

        // Get all the values from the form inputs
        const data = {
            user_id: document.getElementById('user-id').value,
            act_name: document.getElementById('act-name').value,
            act_type: document.getElementById('act-type').value,
            quantity: document.getElementById('quantity').value,
            date: document.getElementById('date').value
        };

        // Send this data to the Flask API endpoint '/log-activity'
        // This is the "contract" with your teammate.
        fetch('/log-activity', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(result => {
            // Show the server's response (e.g., "Activity Logged!")
            formMessage.textContent = result.message; 
            logForm.reset(); // Clear the form
        })
        .catch(error => console.error('Error:', error));
    });

    
    // --- 2. HANDLE THE "LOAD MY DATA" BUTTON ---
    
    const loadButton = document.getElementById('load-data-btn');
    const resultsContainer = document.getElementById('results-container');

    loadButton.addEventListener('click', () => {
        const userId = document.getElementById('user-id').value;

        // Call the Flask API to get data for this user
        // This is the second "contract" with your teammate.
        fetch(`/get-footprint/${userId}`)
        .then(response => response.json())
        .then(data => {
            resultsContainer.innerHTML = ''; // Clear old results
            
            if (data.length === 0) {
                resultsContainer.innerHTML = '<p>No data found for this user.</p>';
                return;
            }

            // Create a table with the results
            let table = '<table><tr><th>Date</th><th>Activity</th><th>Quantity</th><th>Emission (kg CO2e)</th></tr>';
            
            // This part assumes your teammate's API will send back
            // these specific column names from the database
            data.forEach(row => {
                table += `
                    <tr>
                        <td>${row.calc_date}</td>
                        <td>${row.act_name}</td>
                        <td>${row.quantity}</td>
                        <td>${row.emission_val}</td>
                    </tr>
                `;
            });
            table += '</table>';
            
            // Add the new table to the page
            resultsContainer.innerHTML = table;
        })
        .catch(error => console.error('Error:', error));
    });
});