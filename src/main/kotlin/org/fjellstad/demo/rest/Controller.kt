package org.fjellstad.demo.rest

import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.*
import java.time.LocalTime


@RestController
class Controller {
    @GetMapping(path = ["/hello", "/hello/{name}"], produces = [MediaType.TEXT_PLAIN_VALUE])
    fun hello(@PathVariable(name = "name", required = false) pname: String?): String {
        val name = pname ?: "Stranger"
        return "Hello ${name}, localtime is ${LocalTime.now()}"
    }
}