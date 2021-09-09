.DEFAULT_GOAL: image 

image_name = lab_maas
output_archive = $(image_name).tar.gz

.PHONY: image 
image: $(output_archive)
$(output_archive):
	packer build -var=output_image_name=$(image_name) . 
	lxc image export $(image_name) $(image_name)

.PHONY: clean
clean: 
	rm -f $(output_archive)
