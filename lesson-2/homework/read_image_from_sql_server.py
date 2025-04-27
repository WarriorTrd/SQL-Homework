import pyodbc # SQL SERVER


# Connect to your SQL Server
con_str = "DRIVER={SQL Server};SERVER=DESKTOP-M9B82IB\\MSSQLSERVER01;DATABASE=master;Trusted_Connection=yes;"

con = pyodbc.connect(con_str)
cursor = con.cursor()

# Select only id and photo
cursor.execute("""
    SELECT id, photo FROM photo;
""")

row = cursor.fetchone()

# Unpack id and image data
img_id, image_data = row

# Save the image file
with open(f'image_{img_id}.png', 'wb') as f:
    f.write(image_data)

cursor.close()
con.close()
