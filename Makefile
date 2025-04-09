
up:
	docker-compose up -d 

restart:
	docker-compose down
	docker-compose up -d

bash:
	docker exec -it $(contenedor) bash