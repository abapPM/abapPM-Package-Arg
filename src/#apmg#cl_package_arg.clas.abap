CLASS /apmg/cl_package_arg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

************************************************************************
* Package Arg
*
* Copyright 2025 apm.to Inc. <https://apm.to>
* SPDX-License-Identifier: MIT
************************************************************************
* Similar to npm-package-arg
* https://www.npmjs.com/package/npm-package-arg
************************************************************************
  PUBLIC SECTION.

    " https://github.com/npm/npm-package-arg/blob/main/lib/npa.js
    METHODS constructor
      IMPORTING
        !arg TYPE any.

    METHODS get
      RETURNING
        VALUE(result) TYPE /apmg/if_package_arg=>ty_result.

    METHODS to_string
      RETURNING
        VALUE(result) TYPE string.

    METHODS to_purl
      IMPORTING
        !arg          TYPE string
        !registry     TYPE string DEFAULT 'https://registry.abappm.com'
      RETURNING
        VALUE(result) TYPE /apmg/if_package_arg=>ty_result.

    METHODS resolve
      IMPORTING
        !name         TYPE string
        !spec         TYPE string
      RETURNING
        VALUE(result) TYPE /apmg/if_package_arg=>ty_result.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA npa TYPE /apmg/if_package_arg=>ty_result.

ENDCLASS.



CLASS /apmg/cl_package_arg IMPLEMENTATION.


  METHOD constructor.

  ENDMETHOD.


  METHOD get.

    result = npa.

  ENDMETHOD.


  METHOD resolve.

  ENDMETHOD.


  METHOD to_purl.

  ENDMETHOD.


  METHOD to_string.

  ENDMETHOD.
ENDCLASS.
