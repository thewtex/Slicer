
set(proj JsonCpp)

# Set dependency list
set(${proj}_DEPENDENCIES "")

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED JsonCpp_DIR AND NOT EXISTS ${JsonCpp_DIR})
  message(FATAL_ERROR "JsonCpp_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED JsonCpp_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  set(EXTERNAL_PROJECT_OPTIONAL_ARGS)

  if(APPLE)
    list(APPEND EXTERNAL_PROJECT_OPTIONAL_ARGS
      -DJsonCpp_DEFAULT_CLI_EXECUTABLE_LINK_FLAGS:STRING=-Wl,-rpath,@loader_path/../../../
      )
  endif()

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    # JsonCpp snapshot 2014-01-01 r287
    # ${svn_protocol}://svn.code.sf.net/p/jsoncpp/code/trunk/jsoncpp )
    URL "http://midas3.kitware.com/midas/download/bitstream/337068/JsonCpp_r275.tar.gz"
    URL_MD5 43301ad1118004fbdc69b6f7b14a4cd5
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${proj}-build
    CMAKE_CACHE_ARGS
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags} # Unused
      -DJSONCPP_LIB_BUILD_SHARED:BOOL=ON
      -DJSONCPP_WITH_TESTS:BOOL=OFF
      ${EXTERNAL_PROJECT_OPTIONAL_ARGS}
    INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )
  set(JsonCpp_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

mark_as_superbuild(
  VARS JsonCpp_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
