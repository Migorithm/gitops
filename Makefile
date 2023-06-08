include .env
export $(shell sed 's/=.*//' .env)


	
image-pull-secret:
	./scripts/create_image_pull_secret.sh ${STAGE}
		

image-pull-secret-dev:
	./scripts/create_image_pull_secret.sh ${STAGE}


update-image:
	./scripts/update_image.sh ${STAGE}
