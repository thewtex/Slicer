
set(proj JsonCpp)

# Set dependency list
set(${proj}_DEPENDENCIES )

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

# Sanity checks.
if(DEFINED ${proj}_DIR AND NOT EXISTS ${${proj}_DIR})
  message(FATAL_ERROR "${proj}_DIR variable is defined as ${${proj}_DIR} which corresponds to a nonexistent directory")
endif()

if(NOT DEFINED ${proj}_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  set(${proj}_CMAKE_CXX_FLAGS ${ep_common_cxx_flags})
  if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(${proj}_CMAKE_CXX_FLAGS "${ep_common_cxx_flags} -fPIC")
  endif()

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    URL http://midas3.kitware.com/midas/download/bitstream/337068/JsonCpp_r275.tar.gz
    URL_MD5 43301ad1118004fbdc69b6f7b14a4cd5
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${proj}-build
    CMAKE_CACHE_ARGS
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${${proj}_CMAKE_CXX_FLAGS}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags} # Unused
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DJSONCPP_LIB_BUILD_SHARED:BOOL=OFF
      -DJSONCPP_WITH_TESTS:BOOL=OFF
    INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDENCIES}
      )
  set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

else()
  find_package( ${proj} REQUIRED )
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

mark_as_superbuild(
  VARS JsonCpp_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
