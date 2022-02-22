---

date: 2022-01-23
title: Alternativas a Docker Desktop
tags: ['tech']

---

<!--more-->

El tema del cambio del licenciamiento sobre productos y services de Docker Inc.
se ha discutido en varias publicaciones, sin embargo es muy poco lo que se
encuentra en Español. Por ello hoy quiero compartirte que significa este cambio
para los usuarios y alternativas a uno de sus productos, Docker Desktop, existen
en caso quieras explorarlas.

Por cierto, en caso prefieras escuchar este tema en Inglés puedes hacerlo por
medio de la
[grabación del stream del Docker Captain Bret Fisher](https://www.youtube.com/watch?v=1Al9lzpFzn0&t=223s)
donde habla de ello a detalle.

## Docker Desktop y los cambios en su licencias

Docker Desktop, como su nombre lo indica, es una aplicación de escritorio que
permite a los desarrolladores o entusiastas de la tecnología crear, compartir y
correr contenedores de aplicaciones o microservicios en ambientes que no lo
soportan de manera nativa (cualquier sistema operativo que no sea GNU Linux).

El día 31 de Agosto del 2021, [Docker Inc. anunció el cambio del licenciamiento
de sus produtos y
servicios](https://www.docker.com/blog/updating-product-subscriptions/),
requiriendo a los usuarios suscribirse al plan que mejor se acople a sus
necesidades para antes del 31 de Enero del 2022, entre otros detalles en su
esquema de cobros.

### ¿Quiere decir que tengo que pagar por Docker Desktop? 

No necesariamente, muchos de nosotros podemos usar la suscripción personal
(gratuita) para nuestros proyectos pesonales, consultorías o hobbies. Además,
como explican en la
[publicación original](https://www.docker.com/blog/updating-product-subscriptions/)
pequeñas empresas pueden hacer uso de la suscripción gratuita toda vez esta
tenga menos de 250 empleados y su ingreso bruto anual sea menos de 10 millones
de dólares.

> Our Docker Subscription Service Agreement includes a change to the terms for Docker Desktop:
> Docker Desktop remains free for small businesses (fewer than 250 employees AND less than $10 million in annual revenue), personal use, education, and non-commercial open source projects.

En otras palabras muchas personas y empresas en países de habla hispana
pueden optar por la suscripción gratuita sin ningún problema.

## Alternativas a Docker Desktop

Docker Desktop sigue siendo una gran solución para la productividad de
desarrolladores, aún así no está de más conocer las alternativas existentes en
caso quieras migrar.

Aclaro que para manterner la publicación breve me limitaré a dar un pequeña
descripción de cada alternativa y compartir donde puedes leer más acerca de
ella.

### Rancher desktop

<https://rancherdesktop.io/>

Racher Desktop, se describe a si misma como la alternativa de código abierto que
trae el manejo de Kubernetes y containers al escritorio. Esta solución es
actualmente mantenida por SUSE/Rancher y es la única que trea su propia interfáz
gráfica basada en electron desde el inicio.

Si buscas un experiencia bastante similar a Docker Desktop por su interfáz
gráfica, esta es tu mejor opción.

### Minikube

<https://minikube.sigs.k8s.io/>

Minikube es una herramienta código abierto, mantenida por la comunidad de
Kubernetes sigs, que permite a nuevos usuarios y desarrollores crear ambientes
con Kubernetes localmente desde un CLI.

Si buscas crear ambientes que sean compatibles con el docker CLI sin tener que
levantar Kubernetes, esta es una buena alternativa. Solamente necesitas agregar
`--no-kubernetes` al comando `minikube start`.

### podman machine

<https://podman.io/>

Podman es la alternativa open source, soportada por Red Hat, que trae la audáz
propuesta de ser un reemplazo de Docker para el manejo de contenedores. Entre
los subcomandos del podman CLI está `podman machine`, el cual se encarga de
gestionar las configuraciones de un ambiente virtual para correr contenedores en
sistemas operativos no basados en GNU Linux.

La transición de `docker` a `podman` es tan sencilla como hacer
`alias docker=podman`, hanciendola una opción bastante favorable.

### lima

<https://github.com/lima-vm/lima>

Lima la opción código abierto no oficial de `containerd` para ambientes macOS,
gestionando varias configuraciones nativas por defecto desde un CLI `limactl`.

En caso ya estes trabajando con ambientes productivos de Kubernetes que usan
`containerd` en lugar de `docker-shim`, esta solución te permitirá tener un
ambiente de desarrollo mejor alineado.

### Hazlo tu mismo

Tambien está la opción de configurar tu ambiente local compatible con el
Docker CLI por tu propia cuenta. Ya sea
[instalando Docker en Windows usando WSL](https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9)
ó
[creando tu propio Vagrantfile con todo lo que necesitas dentro de él](https://dhwaneetbhatt.com/blog/run-docker-without-docker-desktop-on-macos).

Estas soluciones suelen ser bastante interesantes. Sin embargo, para
productividad de equipos de desarrollo no suele ser la mejor opción dado que
traen consigo una curva de aprendizaje pronunciada para cada uno de los
integrates del equipo.

## Conclusión

La empresa que provee los servicios de Docker ha cambiado su sistema de
licenciamiento y esquema de cobros. Para muchos en America Latina el cambio no
implica más que crear una cuenta personal en [docker.com](https://docker.com) y
seguir disfurtando de sus servicios y productos de manera gratuita. Aún así, no
está de más conocer que alternativas a Docker Desktop, en caso que tu o el
equipo donde trabajas se vean en la necesidad de migrar.
