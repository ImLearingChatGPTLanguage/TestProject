<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h2><c:out value="${restaurant.name}"/></h2>
<p><c:out value="${restaurant.description}"/></p>
<hr/>

<c:forEach var="categoryGroup" items="${groupedMenuItems}">
    <h3 class="mt-4 mb-3" style="border-bottom: 2px solid #007bff; padding-bottom: 5px;">
        ${categoryGroup.key}
    </h3>

    <div class="row">
        <c:forEach var="item" items="${categoryGroup.value}">
            <div class="col-md-6 col-lg-4 mb-4 d-flex align-items-stretch">
                <div class="card h-100 shadow-sm">
                    <form action="${pageContext.request.contextPath}/cart/add" method="post">
                        <input type="hidden" name="itemId" value="${item.itemId}">

                        <c:choose>
                            <c:when test="${not empty item.imageUrl}">
                                <c:choose>
                                    <c:when test="${item.imageUrl.startsWith('http')}">
                                        <img src="${item.imageUrl}" class="card-img-top" alt="${item.name}" style="height: 200px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}${item.imageUrl}" class="card-img-top" alt="${item.name}" style="height: 200px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/400x200.png?text=No+Image" class="card-img-top" alt="No Image" style="height: 200px; object-fit: cover;">
                            </c:otherwise>
                        </c:choose>

                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><c:out value="${item.name}"/></h5>
                            <p class="card-text text-muted small flex-grow-1"><c:out value="${item.description}"/></p>
                            <p class="card-text fs-5 fw-bold text-danger">
                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </p>
                            <div class="input-group mt-auto">
                                <input type="number" name="quantity" class="form-control" value="1" min="1" aria-label="Số lượng">
                                <button type="submit" class="btn btn-primary">Thêm vào giỏ</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>
</c:forEach>