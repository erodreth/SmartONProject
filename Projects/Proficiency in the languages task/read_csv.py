import csv

def read_csv(file_path):
    data = []
    try:
        with open(file_path, 'r') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                data.append(row)
    except Exception as e:
        return f"Error reading CSV file: {e}"

    return data

# Example usage:
file_path = 'example.csv'
csv_data = read_csv(file_path)
print(csv_data)