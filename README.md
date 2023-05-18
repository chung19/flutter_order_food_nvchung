
#Use proxy Provider and bloc ( based on the bloc pattern's data transmission and collection mechanism) call api layer by layer

MVVM  , Clean Architecture , Restful API

Initialize api request then pass api request to repository from repository call to bloc, then return response communicated via event(compare data types using equatable) and return data in stream builder Main Libary :

Provider,RXDark,Dio,,Equatable...