Thank you for progressing to the next stage of our hiring process.

As part of the technical evaluation, you are required to complete the assigned development task within **24 hours** of receiving this email.

Please follow the instructions below carefully:

- Implement the UI strictly according to the provided **Figma design link**:
    
    [[UI design](https://www.figma.com/design/ygFN0es0drctqfpwVkMRz0/Untitled?node-id=0-1&p=f&t=564v1zDJTRnWBZij-0)]
    
- Integrate the application using the provided **API Base URL and Endpoints**:
    
    API Documentation / Endpoints / Curls : 
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/signup' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "first_name": "John",
    "last_name": "Doe",
    "location": "New York, NY",
    "phone": "+15551234567",
    "email": "[john.doe@example.com](mailto:john.doe@example.com)",
    "password": "SecurePassword123!",
    "confirm_password": "SecurePassword123!"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/login/otp' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "phone": "+15551234567"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/login/otp/verify' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "phone": "+15551234567",
    "otp": "000000"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/login/password' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "email": "[john.doe@example.com](mailto:john.doe@example.com)",
    "password": "SecurePassword123!"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/signup/verify' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "type": "phone",
    "code": "123456"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/signup/create-organization' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "organization": {
    "name": "Acme Corporation",
    "team_size": 50
    }
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/switch-organization' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "organization_id": "string"
    }'
    
    curl -X 'GET' \
    'https://backend-f8tw.onrender.com/api/auth/me' \
    -H 'accept: application/json'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/password-reset/request' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "email": "[john.doe@example.com](mailto:john.doe@example.com)"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/password-reset/verify' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "email": "[john.doe@example.com](mailto:john.doe@example.com)",
    "code": "123456"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/auth/password-reset/complete' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "email": "[john.doe@example.com](mailto:john.doe@example.com)",
    "reset_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "new_password": "NewSecurePassword123!",
    "confirm_password": "NewSecurePassword123!"
    }'
    
    curl -X 'POST' \
    'https://backend-f8tw.onrender.com/api/organization' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "name": "Acme Corporation",
    "email": "[contact@acme.com](mailto:contact@acme.com)",
    "phone": "+1-555-123-4567",
    "address": "123 Main Street, Suite 100",
    "city": "New York",
    "state": "NY",
    "zip_code": "10001",
    "country": "United States",
    "website": "[https://www.acme.com](https://www.acme.com/)",
    "logo": "https://example.com/logo.png",
    "employee_team_size": 50,
    "description": "A leading technology company"
    }'
    
    curl -X 'GET' \
    'https://backend-f8tw.onrender.com/api/organization?page=1&limit=10' \
    -H 'accept: application/json'
    
    curl -X 'GET' \
    'https://backend-f8tw.onrender.com/api/organization/660e8400-e29b-41d4-a716-446655440001' \
    -H 'accept: application/json'
    
    curl -X 'PATCH' \
    'https://backend-f8tw.onrender.com/api/organization/660e8400-e29b-41d4-a716-446655440001' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "name": "Acme Corporation",
    "email": "[contact@acme.com](mailto:contact@acme.com)",
    "phone": "+1-555-123-4567",
    "address": "123 Main Street, Suite 100",
    "city": "New York",
    "state": "NY",
    "zip_code": "10001",
    "country": "United States",
    "website": "[https://www.acme.com](https://www.acme.com/)",
    "logo": "https://example.com/logo.png",
    "employee_team_size": 50,
    "description": "A leading technology company"
    }'
    
    curl -X 'DELETE' \
    'https://backend-f8tw.onrender.com/api/organization/660e8400-e29b-41d4-a716-446655440001' \
    -H 'accept: application/json'
    

        

       
      

- The project must follow **Clean Architecture principles**, ensuring clear separation between Presentation, Domain, and Data layers.
- State management must be implemented using the **BLoC pattern**.
- All API integrations must be handled using **Dio and Dio interceptors**, with properly structured and reusable functions for:
    - GET
    - POST
    - PUT/PATCH (Update)
    - DELETE
- Ensure proper error handling, response modeling, and clean folder structure.

Your submission will be evaluated based on architecture, code quality, scalability, maintainability, naming conventions, and adherence to best practices. Poor structuring, hardcoded values, or tightly coupled logic will negatively impact the evaluation.

Please share your completed project repository link before the deadline.

If you have any clarification questions, feel free to reach out.

