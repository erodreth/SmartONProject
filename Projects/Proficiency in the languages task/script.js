function loadCSV() {
    const fileInput = document.getElementById('fileInput');
    const csvContentDiv = document.getElementById('csvContent');

    const file = fileInput.files[0];

    if (file) {
        // Check the file extension
        const fileExtension = file.name.split('.').pop().toLowerCase();
        if (fileExtension !== 'csv') {
            csvContentDiv.innerText = 'Error: Please select a CSV file.';
            return;
        }

        // Create a FileReader to read the contents of the CSV file
        const reader = new FileReader();

        reader.onload = function(e) {
            // Display the content of the CSV file on the webpage
            csvContentDiv.innerText = e.target.result;
        };

        // Read the contents of the CSV file
        reader.readAsText(file);
    } else {
        csvContentDiv.innerText = 'Please select a file.';
    }
}
