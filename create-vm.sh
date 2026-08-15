echo "Creating VM my-vm in zone ru-central1-a..."

yc compute instance create \
  --name my-vm \
  --zone ru-central1-a \
  --public-ip \
  --preemptible \
  --memory 2 \
  --cores 2 \
  --core-fraction 20 \
  --create-boot-disk image-id=fd84uoseqemi8gihbs05,size=10 \
  --metadata enable-oslogin=true

echo "VM my-vm created."