async function payment(auth) {
    return new Promise((resolve, reject) => {
      braintree.dropin.create({
          authorization: auth,
          selector: '#dropin-container'
        },
        (errCreate, instance) => {
          if (errCreate) {
            console.log("Error", errCreate);
            return reject(errCreate);
          }
          document.getElementById("submit-button").addEventListener("click",
            () => {
              instance.requestPaymentMethod((errRequest, payload) => {
                if (errRequest) {
                  console.log("Error", errRequest);
                  return reject(errRequest);
                }
                return resolve(payload.nonce);
              });
            });
        }
      );
    });
  }