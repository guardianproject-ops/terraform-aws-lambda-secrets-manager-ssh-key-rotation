SOURCES = rotate.py ssh.py ssm.py
ARTIFACTS ?= ../artifacts/lambda

package: clean build
	mkdir -p $(ARTIFACTS)
	cp $(SOURCES) $(ARTIFACTS)
	cp -r package/* $(ARTIFACTS)
	cd $(ARTIFACTS) && zip -r ../lambda-aws-ssh-rotate.zip .

build:
	mkdir -p "${PWD}/package"
	pip3 install -r requirements.txt -t "${PWD}/package" --upgrade
	rm -rf "${PWD}/package/bin"

clean:
	rm -rf package
	rm -rf $(ARTIFACTS)
