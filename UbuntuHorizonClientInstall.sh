#!/bin/bash

set -e

echo "🔧 Starting Ubuntu Omnissa Horizon setup..."

# Step 1: Manual Horizon Client installation reminder
echo "📦 Please ensure you've downloaded the Horizon Client installer from:"
echo "👉 https://customerconnect.omnissa.com/downloads/info/slug/desktop_end_user_computing/vmware_horizon_clients/horizon_8"
echo "Navigate to your Downloads folder and run:"
echo "sudo dpkg -i <horizon client DEB file>"
read -p "Press Enter once Horizon Client is installed..."

# Step 2: Download DoD root certificates
echo "📥 Downloading DoD root certificates..."
wget https://militarycac.com/maccerts/AllCerts.zip -O AllCerts.zip
mkdir -p ~/Temp_DoDCerts
unzip AllCerts.zip -d ~/Temp_DoDCerts
rm AllCerts.zip

# Step 3: Convert all DoDRoot*.cer files to .pem
echo "🔄 Converting all DoDRoot*.cer files to .pem..."
cd ~/Temp_DoDCerts
for cert in DoDRoot*.cer; do
    pem="${cert%.cer}.pem"
    openssl x509 -in "$cert" -out "$pem"
    echo "✅ Converted $cert to $pem"
done

# Step 4: Combine all DoDRoot*.pem files into one
echo "🧩 Combining all DoDRoot*.pem files into one root CA bundle..."
cat DoDRoot*.pem > DoDRootCerts.pem
echo "✅ Created DoDRootCerts.pem"

# Step 5: Copy to Ubuntu's CA directory and convert to .crt
echo "📁 Copying root CA bundle to /usr/local/share/ca-certificates..."
sudo cp DoDRootCerts.pem /usr/local/share/ca-certificates/
sudo mv /usr/local/share/ca-certificates/DoDRootCerts.pem /usr/local/share/ca-certificates/DoDRootCerts.crt

# Step 6: Update CA trust
echo "🔄 Updating CA trust..."
sudo update-ca-certificates
echo "✅ CA trust updated"

# Step 7: Create pkcs11 directory for Omnissa Horizon
echo "📂 Creating pkcs11 directory for Omnissa Horizon..."
sudo mkdir -p /usr/lib/omnissa/horizon/pkcs11

# Step 8: Create symlink to opensc-pkcs11 library
echo "🔗 Creating symlink to opensc-pkcs11.so..."
sudo ln -sf /usr/lib/x86_64-linux-gnu/pkcs11/opensc-pkcs11.so /usr/lib/omnissa/horizon/pkcs11/libopenscpkcs11.so
echo "✅ Symlink created"

# Step 9: Clean up temporary certificate folder
echo "🧹 Cleaning up temporary certificate files..."
cd ~
rm -rf ~/Temp_DoDCerts
echo "✅ Temporary files removed"

echo ""
echo "🎉 Setup complete! You can now launch Omnissa Horizon and use your smart card to log in."
echo "💡 If Horizon was open during setup, restart it to detect the smart card."

