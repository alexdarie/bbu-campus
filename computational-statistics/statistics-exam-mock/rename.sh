i=0
for file in *.jpeg
do
  mv "$file" "image_$i.jpeg"
  ((i=i+1))
done
