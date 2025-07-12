# Check if Drupal site responds
curl -I https://freddie-mac-demo.ddev.site

# Test JSON:API endpoint specifically  
curl -I https://freddie-mac-demo.ddev.site/jsonapi/loan_record/loan_record

# Check DDEV status
cd drupal-site
ddev describe
